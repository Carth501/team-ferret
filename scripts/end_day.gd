
extends Control

@onready var completed_day = $MarginContainer/VBoxContainer/CompletedDay as Label
@onready var expenses_text = $MarginContainer/VBoxContainer/HBoxContainer/MiddleContainer/HBoxContainer/ExpensesText as RichTextLabel
@onready var expenses_nums = $MarginContainer/VBoxContainer/HBoxContainer/MiddleContainer/HBoxContainer/ExpensesNums as RichTextLabel
@onready var current_money = $MarginContainer/VBoxContainer/HBoxContainer/MiddleContainer/CurrentMoney as RichTextLabel
@onready var stats = $MarginContainer/VBoxContainer/HBoxContainer/LeftContainer/Stats as RichTextLabel

@export var startingMoney = 50
@export var savings = 0
@export var salary = 26
var overtime = 0
var sharesBonus = 0
var money = 0
@export var day = 0
@export var rent = -15
@export var food = -5


func _ready():
	update_expenses()
	update_day_text()
	
func update_expenses() -> void:
	if(day==0):
		money = startingMoney
	# Below will be code to update each variable based on previous day performance.
	savings = money
	#salary =
	#overtime =
	#sharesBonus =
	#rent =
	#food =
	money = savings + salary + overtime + sharesBonus + rent + food

func update_day_text() -> void:
	day += 1
	completed_day.text = str("DAY ", day)
	expenses_nums.text = str("[right]\n", savings, 
							"\n", salary, 
							"\n", overtime,
							"\n[color=red]", rent,
							"\n", food,
							"[/color]\n", overtime)
	current_money.text = str("[right]",money)

