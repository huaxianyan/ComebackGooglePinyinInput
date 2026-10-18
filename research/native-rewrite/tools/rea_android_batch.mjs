// Static method evidence through a shared REA installation and its own MCP SDK.
// Usage: node rea_android_batch.mjs REA_DIRECTORY APK QUERIES_JSON NEW_OUTPUT_DIRECTORY
import { createRequire } from 'node:module';
import { resolve, join } from 'node:path';
import fs from 'node:fs/promises';

const [reaDirectory, apk, queriesPath, outputDirectory] = process.argv.slice(2);
if (!reaDirectory || !apk || !queriesPath || !outputDirectory) {
  throw new Error('Provide REA_DIRECTORY, APK, QUERIES_JSON and a new output directory.');
}
const require = createRequire(resolve(reaDirectory, 'package.json'));
const { Client } = require('@modelcontextprotocol/client');
const { StdioClientTransport } = require('@modelcontextprotocol/client/stdio');
const queries = JSON.parse(await fs.readFile(queriesPath, 'utf8'));
const environment = {};
for (const key of ['JAVA_HOME', 'REA_JADX_MCP_JAR', 'REA_JADX_HEAP_MIB', 'REA_JADX_ACTIVE_PROCESSOR_COUNT']) {
  if (process.env[key] !== undefined) environment[key] = process.env[key];
}
const client = new Client({ name: 'pinyin-source-research', version: '1.0.0' });
const transport = new StdioClientTransport({
  command: process.execPath,
  args: [resolve(reaDirectory, 'node_modules/rea-agents/scripts/rea.mjs'), 'mcp'],
  env: environment,
  stderr: 'inherit',
});
// A fresh directory keeps existing evidence intact when a request fails partway.
await fs.mkdir(outputDirectory);
try {
  await client.connect(transport);
  for (const [index, query] of queries.entries()) {
    const result = await client.callTool({
      name: 'inspect_android_method',
      arguments: { ...query, path: resolve(apk) },
    }, { timeout: 150_000 });
    const stem = String(index).padStart(3, '0');
    await fs.writeFile(join(outputDirectory, `${stem}.json`), JSON.stringify(result, null, 2));
    if (result.isError) {
      throw new Error(`REA failed for ${query.class_name}.${query.method_name}; see ${stem}.json.`);
    }
    const method = result.structuredContent.normalized_result;
    if (typeof method.source?.text === 'string') {
      await fs.writeFile(join(outputDirectory, `${stem}.source.txt`), method.source.text);
    }
    console.log(JSON.stringify({
      evidence: stem,
      class_name: query.class_name,
      method: method.method,
      body_status: method.body_status,
      representation: method.representation,
      fell_back: method.fell_back,
    }));
  }
} finally {
  await client.close();
}
