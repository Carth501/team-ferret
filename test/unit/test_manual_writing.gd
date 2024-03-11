extends GutTest

var manual_packed := preload("res://scenes/manual.tscn")
var _manual : manual

func before_all():
	_manual = manual_packed.instantiate()
	add_child(_manual)
	_manual.write_manual(data_libraries_single.error_data)

func after_all():
	_manual.queue_free()

func test_manual_opens():
	assert_true(_manual.is_node_ready())

func test_manual_has_pages_array():
	assert_not_null(_manual.pages)

func test_manual_writes_pages():
	assert_gt(_manual.pages.size(), 0)

func test_manual_writes_E_ANIM_RIG_ERR():
	var entry_25 = _manual.pages[24]
	assert_eq(entry_25.page_number, 25)
	assert_eq(entry_25.error_hex, "C9CB")
	assert_eq(entry_25.index, false)
	assert_eq(entry_25.title, "25. C9CB : Animation Rigging Error")

func test_manual_search_by_hex():
	var index := _manual.find_page_index_by_hex("C9CB")
	assert_eq(index, 24)
