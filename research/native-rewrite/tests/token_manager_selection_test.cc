#include "token_manager_selection.h"
#include <cstdio>
#include <vector>

using namespace comeback::recovered;
int main() {
    struct MatchCase { std::int32_t ds, dl, qs, ql; bool expected; };
    const MatchCase matches[]{
        {7, 16, 7, 16, true},
        {7, 16, -1, 16, true},
        {-1, 16, 7, 16, true},
        {7, 16, 7, 26, true},
        {7, 26, 7, 16, true},
        {7, 16, 8, 16, false},
        {7, 16, 7, 17, false}};
    for (const auto& row : matches) {
        if (MatchesTokenDictionary(row.ds, row.dl, row.qs, row.ql) != row.expected) {
            std::fputs("FAIL: native selector/language matching with symmetric -1/26 wildcards\n", stderr);
            return 1;
        }
    }
    // Successful child records, not a fake dictionary or iterator. Different
    // IDs/auxiliary/identity bits may share a native target class/text key.
    const std::vector<KeyToken> candidates{
        {"same", 0x10000001u, 16, false},
        {"same", 0x90000099u, 26, true},
        {"same", 0x20000001u, 16, false},
        {"Same", 0x10000003u, 16, false},
        {std::string("same\0x", 6), 0x10000004u, 16, false},
        {std::string("same\0y", 6), 0x10000005u, 16, false}};
    ManagerTokenAdmission source(true), target(false);
    std::vector<std::uint32_t> source_ids, target_ids;
    for (const auto& token : candidates) {
        if (source.Include(token)) source_ids.push_back(token.id);
        if (target.Include(token)) target_ids.push_back(token.id);
    }
    const std::vector<std::uint32_t> expected_source{
        0x10000001u, 0x90000099u, 0x20000001u, 0x10000003u, 0x10000004u, 0x10000005u};
    const std::vector<std::uint32_t> expected_target{
        0x10000001u, 0x20000001u, 0x10000003u, 0x10000004u, 0x10000005u};
    if (source_ids != expected_source || target_ids != expected_target) {
        std::fputs("FAIL: source keeps all child tokens; target keeps the first class/text occurrence in input order\n", stderr);
        return 1;
    }
    std::puts("PASS: literal token-dictionary qualification and first target admission with source/target ordering");
}
