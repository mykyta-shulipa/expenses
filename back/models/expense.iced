mongoose = require "mongoose"
require 'datejs'

Expense = mongoose.Schema
	item: 
		type: String
		required: true
	place: 
		type: String
		required: true
	date: 
		type: Date
		default: Date.now
		required: true
		index: true
	price: 
		type: Number
		required: true
		min: 0.01

Expense.statics.getAll = (done) ->
	@find().sort("-date").exec done

Expense.statics.getBetween = (begin, end, done) ->
	@find(date: $gte: begin, $lt: end).sort("-date").exec done

Expense.statics.getThisWeek = (done) ->
	startOfWeek = Date.today().previous().monday()
	endOfWeek = startOfWeek.addDays 7
	@getBetween startOfWeek, endOfWeek, done

Expense.statics.getThisMonth = (done) ->
	startOfMonth = Date.today().moveToFirstDayOfMonth()
	endOfMonth = startOfMonth.addMonths 1
	@getBetween startOfMonth, endOfMonth, done
	
module.exports = mongoose.model "expenses", Expense
