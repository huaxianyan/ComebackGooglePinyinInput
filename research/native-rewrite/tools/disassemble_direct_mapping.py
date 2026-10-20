"""Export bounded ARM64 evidence from the original APK; labels are research names."""
import argparse
import hashlib
import json
import struct
from pathlib import Path
import zipfile


# Virtual addresses recovered from the fixed 4.5.2 ARM64 library, not exported symbols.
REGIONS = {
    "iterator_advance": (0x19C93C, 0x19C984),
    "iterator_exhausted": (0x19C984, 0x19C9A0),
    "iterator_constructor": (0x19CAE8, 0x19CB30),
    "create_iterator": (0x19CB30, 0x19CB7C),
    "expander_constructor": (0x19CB7C, 0x19CBD0),
    "resolve_indirection": (0x19CBF8, 0x19CC2C),
    "read_target_and_score": (0x19CC2C, 0x19CC5C),
    "iterator_current": (0x19CC8C, 0x19CD88),
    "lookup_range": (0x19CFAC, 0x19D0F0),
    "iterator_reset": (0x19D0F0, 0x19D1CC),
    "read_container": (0x19D1CC, 0x19D484),
    "load_container": (0x19D540, 0x19D670),
    "build_score_table": (0x1D1D80, 0x1D1E50),
    "default_score_table": (0x1D1E50, 0x1D1E74),
    "metadata_serialize": (0x19F518, 0x19F5D8),
    "metadata_type_name": (0x19F6C0, 0x19F714),
    "metadata_enum_validator": (0x19F79C, 0x19F7A8),
    "metadata_constructor": (0x19F7A8, 0x19F800),
    "metadata_parse": (0x19FA00, 0x19FC74),
    "user_metadata_serialize": (0x1A3F68, 0x1A4010),
    "user_metadata_type_name": (0x1A42D0, 0x1A4300),
    "user_metadata_parse": (0x1A446C, 0x1A4690),
    "last_sync_time_jni": (0x10E5C4, 0x10E5F0),
    "last_sync_time_accessor": (0x189B90, 0x189C00),
    "last_sync_time_setter": (0x1A142C, 0x1A1448),
    "mutable_image_write": (0x1C6660, 0x1C6798),
    "mutable_image_size": (0x1C6908, 0x1C6994),
    "mutable_header_aware_size": (0x1C6994, 0x1C6A38),
    "mutable_forward_payload_size": (0x1C37C0, 0x1C37C8),
    "dictionary_persist_jni": (0x112768, 0x112834),
    "file_mmap_read_entry": (0x1F59F4, 0x1F5A54),
    "file_mmap_create": (0x1F9C50, 0x1F9DF4),
    "file_mmap_open": (0x1FA038, 0x1FA15C),
    "file_mmap_close": (0x1F9F78, 0x1F9FC0),
    "dictionary_duplicate_jni": (0x10E620, 0x10E650),
    "dictionary_duplicate_accessor": (0x18C3F8, 0x18C484),
    "dictionary_duplicate_model": (0x18C27C, 0x18C3F8),
    "dictionary_compact_jni": (0x10E510, 0x10E544),
    "dictionary_compact_accessor": (0x1899B4, 0x189A2C),
    "dictionary_compact_cutoff": (0x1A39D8, 0x1A3A0C),
    "dictionary_compact_selection": (0x1A3758, 0x1A39D4),
    "dictionary_compact_compare": (0x19FC94, 0x19FCF0),
    "dictionary_compact_heap_sift": (0x1A33E4, 0x1A3544),
    "user_dictionary_size": (0x1A02EC, 0x1A0320),
    "dictionary_compact_partial_sort": (0x1A3544, 0x1A3758),
    "dictionary_compact_entry_read": (0x1A112C, 0x1A11E0),
    "dictionary_compact_iterator": (0x1A1448, 0x1A14B8),
    "mutable_key_iterator_factory": (0x1C4888, 0x1C4960),
    "mutable_key_iterator_initialize": (0x1C620C, 0x1C6254),
    "mutable_key_iterator_done": (0x1C386C, 0x1C3890),
    "mutable_key_iterator_next": (0x1C6190, 0x1C620C),
    "dictionary_compact_remove": (0x1A1A74, 0x1A1BB4),
    "dictionary_association_payload_lookup": (0x1C4D08, 0x1C4E70),
    "generic_model_creator": (0x19A3C0, 0x19A5F0),
    "data_info_update_invalidate": (0x1988A4, 0x198C20),
    "generic_model_load_memory": (0x19A1F4, 0x19A2D4),
    "generic_model_load_file": (0x19B748, 0x19B984),
    "generic_model_empty_chunk": (0x199C44, 0x199C68),
    "generic_model_memory_status": (0x19B984, 0x19BA28),
    "data_model_cache_invalidate": (0x19819C, 0x1981DC),
    "mutable_dictionary_enroll_empty_jni": (0x1125EC, 0x112768),
    "model_chunk_source_memory": (0x199D2C, 0x199D58),
    "data_info_fd_construct": (0x19B1C4, 0x19B22C),
    "data_info_memory_construct": (0x19B22C, 0x19B290),
    "data_info_enroll_checked": (0x19774C, 0x1977C0),
    "file_mmap_fd_read_log": (0x1F5B30, 0x1F5BE8),
    "hmm_factory_construct": (0x138568, 0x13873C),
    "dictionary_model_reference_lock": (0x1976F8, 0x19774C),
    "dictionary_accessor_publish_property": (0x18BBCC, 0x18BCC0),
    "dictionary_accessor_default_property": (0x18B8EC, 0x18B978),
    "dictionary_model_property_get": (0x1A07F4, 0x1A0888),
    "dictionary_property_clear": (0x1F34C0, 0x1F3500),
    "dictionary_property_parse": (0x1F35A8, 0x1F3730),
    "dictionary_property_merge_thunk": (0x1F3554, 0x1F3558),
    "dictionary_property_copy": (0x1F3558, 0x1F35A8),
    "chunk_parse_proto": (0x1D1C74, 0x1D1CB4),
    "protobuf_parse_array": (0x2CA7F4, 0x2CA900),
    "dictionary_accessor_create_jni": (0x10F12C, 0x10F264),
    "dictionary_accessor_create_factory": (0x138010, 0x138018),
    "dictionary_accessor_create_impl": (0x137FB4, 0x138010),
    "dictionary_accessor_file_construct": (0x18BF2C, 0x18C050),
    "dictionary_accessor_initialize": (0x18BE20, 0x18BF2C),
    "dictionary_accessor_ensure_store": (0x18BDE8, 0x18BE20),
    "dictionary_accessor_reload_store": (0x18BD50, 0x18BDE8),
    "dictionary_persist_accessor": (0x189924, 0x1899B4),
    "file_persister_construct": (0x1FA438, 0x1FA44C),
    "file_persister_open": (0x1FA44C, 0x1FA4A4),
    "file_persister_write": (0x1FA400, 0x1FA438),
    "file_persister_flush": (0x1FA31C, 0x1FA34C),
    "file_persister_close": (0x1FA34C, 0x1FA39C),
    "file_persister_destroy": (0x1FA39C, 0x1FA3E0),
    "mutable_image_parse": (0x1C71A4, 0x1C7620),
    "mutable_image_publish": (0x1C7814, 0x1C797C),
    "named_trie_image_read": (0x1C6A38, 0x1C6BD4),
    "aligned_pool_image_read": (0x1C6BD4, 0x1C6CA8),
    "named_fixed_image_read": (0x1C6CA8, 0x1C6E44),
    "variable_fixed_image_read": (0x1DF138, 0x1DF26C),
    "variable_trie_image_write": (0x1DEFA8, 0x1DF138),
    "variable_trie_image_size": (0x1DEE28, 0x1DEFA8),
    "variable_trie_image_parse": (0x1DF26C, 0x1DF43C),
    "variable_trie_image_publish": (0x1DF43C, 0x1DF4C0),
    "named_trie_image_write": (0x1C63C4, 0x1C64D4),
    "aligned_pool_image_write": (0x1C64D4, 0x1C6550),
    "named_fixed_image_write": (0x1C6550, 0x1C6660),
    "datrie_backend_name": (0x1D6AC0, 0x1D6AF0),
    "variable_trie_backend_name": (0x1DE430, 0x1DE484),
    "fixed_table_backend_name": (0x1F2F0C, 0x1F2F34),
    "dictionary_string_write": (0x1F5D80, 0x1F5E3C),
    "dictionary_string_read": (0x1F6158, 0x1F61C0),
    "dictionary_string_body_read": (0x1F60C4, 0x1F6158),
    "protobuf_write_bytes": (0x2CB62C, 0x2CB744),
    "mutable_metadata_serialize": (0x1D393C, 0x1D3A2C),
    "mutable_metadata_type_name": (0x1D3A2C, 0x1D3A80),
    "mutable_metadata_parse": (0x1D3F04, 0x1D41CC),
    "mutable_metadata_defaults": (0x1D3C0C, 0x1D3C20),
    "protobuf_write_int32": (0x2CB014, 0x2CB04C),
    "get_expansion_category": (0x19C9C4, 0x19C9DC),
    "manager_apply_iterator": (0x196874, 0x196AF0),
    "manager_reset": (0x196AF0, 0x196BEC),
    "manager_register": (0x196D30, 0x196FF0),
    "manager_create_iterator": (0x197348, 0x1974A4),
    "manager_compare_insert": (0x196684, 0x1967CC),
    "manager_current": (0x196074, 0x196224),
    "manager_advance": (0x196650, 0x196684),
    "triple_category_client": (0x18CAA0, 0x18CBAC),
    "token_decoder_constructor": (0x1751AC, 0x17522C),
    "decoder_configure_categories": (0x17522C, 0x1752F8),
    "fuzzy_client_prefix": (0x130044, 0x130190),
    "key_context_refresh": (0x18BE20, 0x18BF2C),
    "key_token_equal": (0x18C620, 0x18C658),
    "key_input_validate": (0x18CCB0, 0x18CE40),
    "key_collect_expansions": (0x18D07C, 0x18D258),
    "key_normalize_prune": (0x18D424, 0x18D5D4),
    "key_english_generation": (0x18E264, 0x18E380),
    "key_digit_expansion": (0x18E0E8, 0x18E264),
    "fast_exp": (0x18C56C, 0x18C5AC),
    "fast_log": (0x18C5D8, 0x18C61C),
    "log_score_add": (0x18C69C, 0x18C72C),
    "learning_jni_legacy": (0x111E14, 0x111F08),
    "learning_jni_add_count": (0x111F08, 0x112048),
    "learning_accessor_legacy": (0x189D94, 0x189E28),
    "learning_accessor_add_count": (0x18A68C, 0x18A91C),
    "learning_text_size_gate": (0x1896D4, 0x189704),
    "learning_shared_store": (0x189910, 0x189924),
    "learning_generate_keys": (0x18E380, 0x18EAE8),
    "learning_store_add": (0x1A1D9C, 0x1A1E54),
    "learning_store_lookup": (0x1A14B8, 0x1A153C),
    "learning_store_update_existing": (0x1A1894, 0x1A1A40),
    "learning_store_ensure_count": (0x1A1BB4, 0x1A1D9C),
    "learning_store_remove": (0x1A1A74, 0x1A1BB4),
    "learning_store_aggregate": (0x1A0CBC, 0x1A0CE0),
    "learning_store_day": (0x1A0CE0, 0x1A0D08),
    "payload_v21_encode": (0x1A0888, 0x1A09A4),
    "payload_v21_decode": (0x1A05C0, 0x1A06D8),
    "payload_v10_encode": (0x1A09A4, 0x1A0A98),
    "payload_v10_decode": (0x1A06D8, 0x1A07F4),
    "payload_read_bytes": (0x1F5BE8, 0x1F5C40),
    "payload_write_bytes": (0x1F5CA4, 0x1F5D00),
    "dictionary_initialize": (0x1A259C, 0x1A281C),
    "dictionary_load_payload": (0x1A2B38, 0x1A3130),
    "dictionary_accept_loaded": (0x1A3C9C, 0x1A3E04),
    "mutable_dictionary_build": (0x1A6A2C, 0x1A6DD4),
    "mutable_dictionary_constructor": (0x1C5DE8, 0x1C5E64),
    "mutable_editor_get": (0x1C5C84, 0x1C5DA0),
    "mutable_editor_constructor": (0x1C5A00, 0x1C5C84),
    "mutable_editor_ensure": (0x1C5F08, 0x1C5F78),
    "mutable_editor_update": (0x1C5FE8, 0x1C6074),
    "mutable_editor_modify": (0x1C5660, 0x1C59A0),
    "mutable_editor_remove": (0x1C52AC, 0x1C54AC),
    "mutable_editor_key": (0x1C4494, 0x1C4618),
    "dictionary_serialize": (0x1A2228, 0x1A23B4),
    "header_crc_empty": (0x1F636C, 0x1F6380),
    "header_crc_extend": (0x1F6594, 0x1F6C44),
    "table_crc64_extend": (0x1F6C44, 0x1F7464),
    "table_crc64_initialize": (0x1F96CC, 0x1F98B8),
    "header_crc_table": (0x1F8B88, 0x1F8CBC),
    "header_crc_new": (0x1F9158, 0x1F939C),
    "header_crc_factory": (0x1F939C, 0x1F947C),
    "header_crc_default": (0x1F9AA4, 0x1F9B34),
    "header_crc_window": (0x1F8CBC, 0x1F8DC4),
    "association_reference_decode": (0x1C39CC, 0x1C3A30),
    "association_trie_value_patch": (0x1C4348, 0x1C4494),
    "association_record_patch": (0x1C3A30, 0x1C3AC8),
    "association_pair_record_patch": (0x1C80CC, 0x1C8190),
    "association_record_read": (0x1C3AC8, 0x1C3B40),
    "association_record_key": (0x1C3B40, 0x1C3B68),
    "association_find_key": (0x1C3B68, 0x1C3C30),
    "association_find_pair": (0x1C7FF4, 0x1C80CC),
    "association_pair_record_read": (0x1C7F7C, 0x1C7FF4),
    "association_record_update": (0x1C51C4, 0x1C524C),
    "association_list_append": (0x1C5120, 0x1C51C4),
    "association_pool_first": (0x1E4DD4, 0x1E4E3C),
    "association_pool_insert": (0x1E4E3C, 0x1E5028),
    "pool_record_write": (0x1E3F18, 0x1E3F70),
    "pool_record_read": (0x1E3F70, 0x1E3FC8),
    "pool_record_read_checked": (0x1E3FC8, 0x1E4028),
    "pool_is_free": (0x1E4028, 0x1E4070),
    "pool_free_length": (0x1E4070, 0x1E40A4),
    "pool_free_next": (0x1E40A4, 0x1E40D0),
    "pool_free_previous": (0x1E40D0, 0x1E41A8),
    "pool_tail": (0x1E41A8, 0x1E41B8),
    "pool_first_fit": (0x1E41B8, 0x1E4244),
    "pool_adjacent_runs": (0x1E4244, 0x1E43C4),
    "pool_list_predecessor": (0x1E43C4, 0x1E44AC),
    "pool_range_valid": (0x1E44B8, 0x1E4508),
    "pool_list_successor": (0x1E44AC, 0x1E44B8),
    "pool_free_link": (0x1E4508, 0x1E45B4),
    "pool_list_neighbors": (0x1E45B4, 0x1E463C),
    "pool_coalesce": (0x1E463C, 0x1E47E4),
    "pool_release": (0x1E47E4, 0x1E4870),
    "pool_fill_and_split": (0x1E4A20, 0x1E4B44),
    "pool_allocate": (0x1E4B44, 0x1E4DD4),
    "pool_construct": (0x1E3B6C, 0x1E3B94),
    "pool_initialize": (0x1E3BDC, 0x1E3C50),
    "pool_serialized_size": (0x1E3BB8, 0x1E3BDC),
    "pool_checksum": (0x1E3C50, 0x1E3CF0),
    "pool_load": (0x1E3CF0, 0x1E3E4C),
    "pool_serialize": (0x1E3E4C, 0x1E3F18),
    "buffer_mmap_construct": (0x1FA4A4, 0x1FA4E0),
    "buffer_assign": (0x1FA508, 0x1FA554),
    "buffer_slice": (0x1FA554, 0x1FA580),
    "buffer_data": (0x1FA610, 0x1FA620),
    "buffer_mutable_data": (0x1FA5A8, 0x1FA610),
    "buffer_size": (0x1FA620, 0x1FA630),
    "buffer_resize_exact": (0x1FA780, 0x1FA788),
    "buffer_resize_shared": (0x1FA6AC, 0x1FA780),
    "region_initialize": (0x1FA790, 0x1FA7B0),
    "region_mmap_initialize": (0x1FA7B0, 0x1FA84C),
    "region_slice": (0x1FA8B8, 0x1FA928),
    "region_slice_initialize": (0x1FA880, 0x1FA8B8),
    "region_release": (0x1FA988, 0x1FA9D4),
    "region_destroy": (0x1FA928, 0x1FA988),
    "region_clone": (0x1FACDC, 0x1FAD58),
    "region_mutable_data": (0x1FAB6C, 0x1FABCC),
    "region_detach": (0x1FAAB8, 0x1FAB6C),
    "region_resize": (0x1FABCC, 0x1FACDC),
    "region_data": (0x1FA870, 0x1FA878),
    "region_size": (0x1FA878, 0x1FA880),
    "region_ref_count": (0x1FA868, 0x1FA870),
    "datrie_remove_key": (0x1D6E78, 0x1D7038),
    "datrie_count_children": (0x1D54F0, 0x1D559C),
    "datrie_insert_value": (0x1D688C, 0x1D6A64),
    "datrie_relocate_children": (0x1D6410, 0x1D66CC),
    "datrie_resolve_collision": (0x1D66CC, 0x1D688C),
    "node_id_updator": (0x1C5520, 0x1C5660),
    "datrie_read_by_id": (0x1D6388, 0x1D6410),
    "variable_trie_read_by_id": (0x1DEAA0, 0x1DEB4C),
    "trie_value_resolve": (0x1DE920, 0x1DE9E4),
    "association_update_match": (0x1C54AC, 0x1C5520),
    "datrie_copy_terminal_value": (0x1D62B0, 0x1D630C),
    "datrie_initialize_nodes": (0x1D5158, 0x1D51E8),
    "datrie_initialize": (0x1D51E8, 0x1D538C),
    "datrie_return_node": (0x1D53E8, 0x1D5434),
    "datrie_enumerate_children": (0x1D559C, 0x1D5654),
    "datrie_grow_nodes": (0x1D4E5C, 0x1D4FE8),
    "datrie_find_base": (0x1D4FE8, 0x1D5128),
    "datrie_unlink_free_node": (0x1D5128, 0x1D5158),
    "datrie_accept_byte": (0x1D4BF0, 0x1D4C34),
    "datrie_accept_key": (0x1D4C34, 0x1D4C9C),
    "datrie_read_terminal_key": (0x1D6AF0, 0x1D6CA4),
    "datrie_first_terminal": (0x1D5BC8, 0x1D5CCC),
    "datrie_next_terminal": (0x1D5EE0, 0x1D60E4),
    "datrie_find_node": (0x1D4D2C, 0x1D4DEC),
    "datrie_find_root": (0x1D4E24, 0x1D4E2C),
    "datrie_load_image": (0x1D7970, 0x1D7B94),
    "datrie_serialize_image": (0x1D5A98, 0x1D5B9C),
    "datrie_image_size": (0x1D45F0, 0x1D4628),
    "datrie_image_checksum": (0x1D59F8, 0x1D5A98),
    "datrie_validate_parents": (0x1D75CC, 0x1D7970),
    "datrie_validate_free_chain": (0x1D5434, 0x1D54BC),
    "datrie_is_free": (0x1D54BC, 0x1D54F0),
    "datrie_is_terminal": (0x1D5654, 0x1D56CC),
    "datrie_update_terminal": (0x1D5914, 0x1D5998),
    "datrie_editor_update": (0x1D5998, 0x1D59F8),
    "trie_value_append": (0x1DEB4C, 0x1DEC04),
    "trie_value_update": (0x1DECA0, 0x1DED68),
    "trie_editor_create": (0x1DEC04, 0x1DECA0),
    "trie_editor_update": (0x1DED68, 0x1DEE28),
    "trie_editor_remove": (0x1DE270, 0x1DE294),
    "trie_editor_destroy": (0x1DE734, 0x1DE768),
    "trie_key_admission": (0x1DE3A8, 0x1DE3DC),
    "dictionary_key_admission": (0x1C5E64, 0x1C5F08),
    "trie_value_builder": (0x1BFBFC, 0x1C00C0),
    "pool_erase_record": (0x1E4870, 0x1E4A20),
    "association_remove_key": (0x1C524C, 0x1C52AC),
    "phrase_construct": (0x1F2F70, 0x1F2FBC),
    "phrase_initialize": (0x1F2C8C, 0x1F2CB4),
    "phrase_read": (0x1F2D90, 0x1F2E20),
    "phrase_mutable_record": (0x1F2E20, 0x1F2EB0),
    "phrase_append": (0x1F3178, 0x1F3254),
    "phrase_grow": (0x1F30EC, 0x1F3178),
    "phrase_clear": (0x1F2EB0, 0x1F2EE0),
    "phrase_count": (0x1F2CB4, 0x1F2CCC),
    "phrase_ready": (0x1F2CCC, 0x1F2CD4),
    "phrase_load": (0x1F3060, 0x1F30EC),
    "phrase_parse_image": (0x1F2FBC, 0x1F3060),
    "phrase_serialize": (0x1F2D04, 0x1F2D90),
    "phrase_serialized_size": (0x1F2EE0, 0x1F2F0C),
    "storage_read_aligned": (0x1F5C40, 0x1F5CA4),
    "storage_slice": (0x1F5E3C, 0x1F5EC4),
    "storage_slice_aligned": (0x1F5EC4, 0x1F5F20),
    "storage_write_aligned": (0x1F5D00, 0x1F5D80),
    "storage_write_region_aligned": (0x1F5F20, 0x1F5FCC),
    "bounded_bytes_write": (0x1F5CA4, 0x1F5D00),
    "buffer_zero": (0x1FA65C, 0x1FA6AC),
}
SCORE_TABLE_POINTER = 0x699358
SCORE_TABLE_SPANS = {
    "LogMantissa": (0x000, 128),
    "LogSlope": (0x200, 128),
    "ExpMantissa": (0x400, 128),
    "ExpResidual": (0x600, 256),
}
SCORE_CONSTANTS = {
    "Log2E": 0x18C5AC, "ExpBias": 0x18C5B0,
    "Ln2": 0x18C61C, "LogAddLimit": 0x18C730,
}
DECODER_CATEGORY_TABLE = (0x349D10, 0x349D18)
DICTIONARY_CRC_CONFIGS = {
    "dictionary_header_crc": 0x34EC50,
    "association_key_crc": 0x34EAD0,
    "table_crc64": 0x34EF50,
}
RELOCATION_REGIONS = {
    "direct_iterator": (0x67A7B0, 0x67A7E8),
    "manager_iterator": (0x67A488, 0x67A4C8),
    "manager": (0x67A4D8, 0x67A500),
    "manager_typeinfo": (0x68AF28, 0x68AF58),
    "metadata": (0x68B278, 0x68B300),
    "crc64": (0x67E250, 0x67E298),
    "fixed_phrase_table": (0x67E0E0, 0x67E148),
    "datrie": (0x67D5E0, 0x67D640),
    "mutable_dictionary_metadata": (0x68C990, 0x68CA18),
    "user_dictionary_metadata": (0x68B790, 0x68B818),
    "mutable_dictionary": (0x67C300, 0x67C3D0),
    "file_storage_persister": (0x67E300, 0x67E338),
    "mutable_dictionary_accessor": (0x67A060, 0x67A138),
    "variable_value_trie": (0x67DD30, 0x67DDD8),
    "token_decoder_typeinfo": (0x68AA90, 0x68AAA8),
    "token_decoder_vtable": (0x68AAB8, 0x68AAF8),
}
STRING_ANCHORS = {
    0x32C3CB: "[DirectMappingTokenExpander] Failed to load the key ids table.",
    0x32C40A: "[DirectMappingTokenExpander] Failed to load the start position table.",
    0x32C450: "[DirectMappingTokenExpander] Failed to load target id table.",
    0x32C48D: "[DirectMappingTokenExpander] Failed to load expansion score table.",
    0x32C4D0: "[DirectMappingTokenExpander] Failed to load the meta data table.",
    0x32C89D: "i18n_input.engine.hmm.proto.TokenExpanderMetaData",
    0x34A9B0: "N10i18n_input6engine3hmm20TokenExpanderManagerE",
    0x34A9E0: "N10i18n_input6engine3hmm20TokenExpanderManager15ManagerIteratorE",
    0x349CE0: "N10i18n_input6engine3hmm16TokenDecoderBaseE",
    0x32B90D: "i18n/input/engine/hmm/internal/storage/key_generator.cc",
    0x32B945: "The size of language_ids and source tokens are not equal.(",
    0x32B985: "Token dictionary manager contains multi dictionaries ",
    0x32B9BB: "but the source token language id is: UNKNOWN_LANGUAGE.",
}


def decode_direct_branch(word, address):
    """Decode an AArch64 immediate B/BL, using its signed instruction offset."""
    if word & 0x7C000000 != 0x14000000:
        return None
    immediate = word & 0x3FFFFFF
    if immediate & (1 << 25):
        immediate -= 1 << 26
    return {"address": address, "target": address + immediate * 4,
            "kind": "bl" if word & 0x80000000 else "b"}


def find_direct_branches(binary, targets):
    """List immediate B/BL references, not indirect calls or runtime reachability."""
    section = binary.get_section(".text")
    content = bytes(section.content)
    names = {address: name for name, address in targets.items()}
    result = {name: [] for name in targets}
    for offset, (word,) in enumerate(struct.iter_unpack("<I", content)):
        branch = decode_direct_branch(word, section.virtual_address + offset * 4)
        if branch is not None and branch["target"] in names:
            result[names[branch["target"]]].append(branch)
    return result


def capture_score_math(binary, pointer_address=SCORE_TABLE_POINTER):
    relocations = {item.address: item for item in binary.relocations}
    address = relocations[pointer_address].addend
    tables = {}
    for name, (offset, count) in SCORE_TABLE_SPANS.items():
        content = bytes(binary.get_content_from_virtual_address(address + offset, count * 4))
        tables[name] = {"address": address + offset,
                        "words": [word for (word,) in struct.iter_unpack("<I", content)],
                        "sha256": hashlib.sha256(content).hexdigest()}
    constants = {name: {"address": location, "bits": struct.unpack("<I", bytes(
        binary.get_content_from_virtual_address(location, 4)))[0]}
        for name, location in SCORE_CONSTANTS.items()}
    cutoff = bytes(binary.get_content_from_virtual_address(0x18D5D4, 4))
    return {"pointer_address": pointer_address, "table_address": address,
            "tables": tables, "constants": constants,
            "normalization_cutoff": {"address": 0x18D5D4, "bits": struct.unpack("<I", cutoff)[0]}}


def write_score_table_header(path, captured):
    lines = ["// Fixed Google Pinyin 4.5.2 ARM64 math data; regenerate with the research exporter.",
             "// Google-derived material remains subject to NOTICE, not a new MPL grant."]
    for name, item in captured["constants"].items():
        lines.append(f"constexpr std::uint32_t k{name}Bits = 0x{item['bits']:08x}u;")
    for name, item in captured["tables"].items():
        words = item["words"]
        lines.append(f"constexpr std::uint32_t k{name}Bits[] = {{")
        for offset in range(0, len(words), 8):
            lines.append("    " + ", ".join(f"0x{word:08x}u" for word in words[offset:offset+8]) + ",")
        lines.append("};")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main():
    import lief
    from capstone import Cs, CS_ARCH_ARM64, CS_MODE_ARM

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apk", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--score-table-header", type=Path,
                        help="write checked-in C++ math constants; not part of the product build")
    args = parser.parse_args()
    entry = "lib/arm64-v8a/libhmm_gesture_hwr_zh.so"
    with zipfile.ZipFile(args.apk) as archive:
        content = archive.read(entry)
    binary = lief.ELF.parse(list(content))
    if binary is None:
        raise ValueError("could not parse the core library")
    for address, text in STRING_ANCHORS.items():
        actual = bytes(binary.get_content_from_virtual_address(address, len(text) + 1))
        if actual != text.encode() + b"\0":
            raise ValueError(f"fixed-APK string anchor mismatch at {address:#x}")
    disassembler = Cs(CS_ARCH_ARM64, CS_MODE_ARM)
    regions = {}
    for label, (start, end) in REGIONS.items():
        data = bytes(binary.get_content_from_virtual_address(start, end - start))
        instructions = [
            {"address": ins.address, "mnemonic": ins.mnemonic, "operands": ins.op_str}
            for ins in disassembler.disasm(data, start)
        ]
        if len(instructions) * 4 != end - start:
            raise ValueError(f"incomplete ARM64 disassembly in {label}")
        regions[label] = {
            "start": start, "end": end,
            "sha256": hashlib.sha256(data).hexdigest(),
            "instructions": instructions,
        }
    relocations = sorted(binary.relocations, key=lambda item: item.address)
    start, end = DECODER_CATEGORY_TABLE
    category_bytes = bytes(binary.get_content_from_virtual_address(start, end - start))
    crc_configurations = {}
    for label, address in DICTIONARY_CRC_CONFIGS.items():
        config = bytes(binary.get_content_from_virtual_address(address, 24))
        low, high, degree = struct.unpack("<QQI", config[:20])
        crc_configurations[label] = {"address": address, "low": low, "high": high, "degree": degree}
    result = {
        "library_entry": entry,
        "library_sha256": hashlib.sha256(content).hexdigest(),
        "address_space": "ELF virtual address, before runtime relocation",
        "labels": "research annotations, not recovered C++ symbol names",
        "string_anchors": {hex(address): text for address, text in STRING_ANCHORS.items()},
        "regions": regions,
        "score_math": capture_score_math(binary),
        **crc_configurations,
        "decoder_category_table": {
            "address": start,
            "u32_values": list(struct.unpack("<II", category_bytes)),
            "sha256": hashlib.sha256(category_bytes).hexdigest(),
        },
        "direct_branch_references": find_direct_branches(binary, {
            name: REGIONS[name][0] for name in (
                "manager_create_iterator", "decoder_configure_categories",
                "triple_category_client",
            )
        }),
        "relocation_regions": {
            label: [
                {"address": relocation.address, "type": str(relocation.type),
                 "target": relocation.addend}
                for relocation in relocations if start <= relocation.address < end
            ]
            for label, (start, end) in RELOCATION_REGIONS.items()
        },
    }
    if args.score_table_header:
        write_score_table_header(args.score_table_header, result["score_math"])
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"exported {len(regions)} ARM64 regions to {args.output}")


if __name__ == "__main__":
    main()
