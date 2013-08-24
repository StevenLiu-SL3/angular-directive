'use strict';

mainApp=angular.module('f4DirectivesApp', ['myF4DirectiveApp'])

mainController= ($scope)->
	# model object
	$scope.selectedPerson = new Object()
	# $scope.dropDownListData for dropdown list
	$scope.dropdownListData = [
											{name:"John"}
											{name:"Susan"}
										]



controllers={}

controllers.mainController=mainController

mainApp.controller controllers
