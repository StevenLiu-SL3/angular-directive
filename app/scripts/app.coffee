'use strict';

mainApp=angular.module('f4DirectivesApp', ['myF4DirectiveApp'])

mainController= ($scope)->
  
   

	# model object
	$scope.selectedPerson = new Object()
	$scope.alertContent = "Alert box content"
	# $scope.dropDownListData for dropdown list
	$scope.dropdownListData = [
											{name:"John"} 
											{name:"Susan"}
										]
  imageListType=typeof $scope.imageListData
	if imageListType == "undefined"
	  $scope.imageListData=null
  $scope.imageListData1 = [
                      {imageSrc:"20130723_135624.jpg",imageThSrc:"thumb.20130723_135624.jpg",caption:"",featured:false}
                      {imageSrc:"20130723_135805.jpg",imageThSrc:"thumb.20130723_135805.jpg",caption:"",featured:false}
                      {imageSrc:"20130723_140100.jpg",imageThSrc:"thumb.20130723_140100.jpg",caption:"",featured:false}
                      {imageSrc:"20130723_140218.jpg",imageThSrc:"thumb.20130723_140218.jpg",caption:"",featured:false}
                    ] 
  $scope.imageListData2 = [
                      {imageSrc:"20130723_140508.jpg",imageThSrc:"thumb.20130723_140508.jpg",caption:"",featured:false}
                      {imageSrc:"20130723_141319.jpg",imageThSrc:"thumb.20130723_141319.jpg",caption:"",featured:false}
                      {imageSrc:"20130723_142225.jpg",imageThSrc:"thumb.20130723_142225.jpg",caption:"",featured:false}
                      {imageSrc:"20130723_142525.jpg",imageThSrc:"thumb.20130723_142525.jpg",caption:"",featured:false}
                    ]
  if $scope.imageListData == null
    $scope.imageListData = $scope.imageListData1
  $scope.imageToggle=false
  
  $scope.onChangeImageList=()->
    $scope.imageToggle=!$scope.imageToggle
    if $scope.imageToggle
      $scope.imageListData=$scope.imageListData2
    else
      $scope.imageListData=$scope.imageListData1
    
  return

controllers={}

controllers.mainController=mainController

mainApp.controller controllers
