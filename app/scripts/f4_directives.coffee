'use strict'

myF4_DirectiveApp=angular.module('myF4DirectiveApp',[])

### Example
  <mp-dropdown dropdown-title="Roles" dropdown-list="Roles" dropdown-model="User.user_data.role_row" dropdown-var="va" dropdown-split-button dropdown-repeat-text="va.role_data.role" dropdown-button-class="button split" dropdown-split-button></mp-dropdown>
   
   where dropdown-list is a scope variable array, dropdown-model is a element of the array     
###
mpdropdownDirective = ($parse,$compile,$timeout)->

  valueIdentifier = null
  keyIdentifier  = null
  scopeVariableName = null
  type = (obj) ->
    if obj == undefined or obj == null
      return String obj
    classToType = {
      '[object Boolean]': 'boolean',
      '[object Number]': 'number',
      '[object String]': 'string',
      '[object Function]': 'function',
      '[object Array]': 'array',
      '[object Date]': 'date',
      '[object RegExp]': 'regexp',
      '[object Object]': 'object'
    }
    return classToType[Object.prototype.toString.call(obj)]
   
  setValueIdentifier=(vi)->
    valueIdentifier=vi
  getValueIdentifier=()->
    return valueIdentifier
  
  setKeyIdentifier=(vi)->
    keyIdentifier=vi
  getKeyIdentifier=()->
    return keyIdentifier        
  setScopeVariableName = (sv)->
    scopeVariableName=sv
  getScopeVariableName = ()->
    return scopeVariableName
  selectItem = (self,index)->  
    i=index       
  randomString = (length, chars)->
    i = length
    result=''
    while i > 0
      result += chars[Math.round(Math.random()*(chars.length-1))]
      --i
    return result
  
  getRandomName = (prefix)->
    p1=randomString 28, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    p2=randomString 4, '0123456789'
    newname=prefix+p1+p2
    return newname
  selectItem = ()->
    i=0
    return 
  hashKey = (obj)->
    i=0
    return  
  directiveDefinitionObject = {
    scope: {
        dropdownModel: '='
        dropdownRepeat: '@'
        dropdownRepeatText: '='
        dropdownTitle: '@'
        dropdownList: '='
        dropdownVar: '@'
        dropdownButtonClass: '@'
        dropdownSplitButton: '='
       
    }
    priority: 0
    ###
    template: '<div>'+
              '<a ng-href="" data-dropdown="drop1">Has dropdown</a>'+
              '<ul id="drop1" class="f-dropdown" data-dropdown-content>'+     
              '<li ><a data-ng-href="selectItem(this,idx)" data-ng-click="selectItem(this)"></a></li>'+
              '</ul>'+
              '</div>'
    ###
    #
    #template: '<div>'+
    #          '<a ng-href="" data-dropdown="drop1">Has dropdown</a>'+
    #          '<ul id="drop1" class="f-dropdown" data-dropdown-content>'+     
    #          '<li ><a ></a></li>'+
    #          '</ul>'+
    #          '</div>'
    
    replace: true
    trsnaclude: false
    restrict: 'AE'
    controller: [
      "$scope"
      "$element"
      "$attrs"
      "$transclude"
      "$timeout"
      ($scope,$element,$attrs,$transclude,$timeout)->
       
        setValueIdentifier($attrs.dropdownVar)
        setScopeVariableName($attrs.dropdownList)
        uniqAId=getRandomName("dropdown_")
        if $scope.dropdownButtonClass
          buttonClass=$scope.dropdownButtonClass
        else
          buttonClass="button dropdown" 
        stemplate1=''
        if $attrs.dropdownSplitButton?
          stemplate1= '<div>'+'<a ng-href="" data-dropdown="{0}" class="{1}">{2}<span data-dropdown="{0}"></span></a>'
        else  
          stemplate1= '<div>'+'<a ng-href="" data-dropdown="{0}" class="{1}">{2}</a>'
        stemplate1=stemplate1.replace("{0}",uniqAId)
        stemplate1=stemplate1.replace("{0}",uniqAId)
        stemplate1=stemplate1.replace("{1}",buttonClass)        
        stemplate1=stemplate1.replace("{2}",$scope.dropdownTitle)
        stemplate2='<ul id="{0}" class="f-dropdown" data-dropdown-content>'
        stemplate2=stemplate2.replace("{0}",uniqAId)       
        stemplate3='<li ><a data-ng-click="{0}">{1}</a></li>'
        stemplate4='</ul>'+'</div>'
        stemplate=""
        resolved=$scope.dropdownList?.$resolved?
        if type(resolved) is not undefined and resolved==false
          $scope.dropdownList.$promise.then (value)->
            i=0
            iLength=value.length
            smiddle=""
            while i<iLength
              v=value[i]
              vi=getValueIdentifier()
              tempObj=new Object()
              vaGetter=$parse(vi)
              vaSetter=vaGetter.assign
              vaSetter(tempObj,v)
              vaTextGetter=$parse($attrs.dropdownRepeatText)
              txt=vaTextGetter(tempObj)
              fnName="selectItem(this,"+i+")" 
              smiddle1=stemplate3.replace("{0}",fnName)
              smiddle2=smiddle1.replace("{0}",fnName)
              smiddle3=smiddle2.replace("{1}",txt)
              smiddle=smiddle+smiddle3
              i++
            stemplate=stemplate1+stemplate2+smiddle+stemplate4
            $element.append($compile(stemplate)($scope))    
        else
          value=$scope.dropdownList
          i=0
          iLength=value.length
          smiddle=""
          while i<iLength
            v=value[i]
            vi=getValueIdentifier()
            tempObj=new Object()
            vaGetter=$parse(vi)
            vaSetter=vaGetter.assign
            vaSetter(tempObj,v)
            vaTextGetter=$parse($attrs.dropdownRepeatText)
            txt=vaTextGetter(tempObj)
            fnName="selectItem(this,"+i+")" 
            smiddle1=stemplate3.replace("{0}",fnName)
            smiddle2=smiddle1.replace("{0}",fnName)
            smiddle3=smiddle2.replace("{1}",txt)
            smiddle=smiddle+smiddle3
            i++
          stemplate=stemplate1+stemplate2+smiddle+stemplate4
          $element.append($compile(stemplate)($scope))    
              
        sc=getScopeVariableName()
        $scope.selectItem = (self,idx)->
          self1=self
          i=idx
          resolved=this.dropdownList?.$resolved?
          if type(resolved) is not undefined and resolved==false
            this.dropdownList.$promise.then (value)->
              this.dropdownModel=value[idx]
              
          else
            this.dropdownModel=this.dropdownList[idx]
           
            
          return    

      
        return 
    ]
    link: (scope, iElement, iAttrs,$timeout)=>
      aElm=iElement.find("a")
      ulElm=iElement.find("ul")
      liElm=iElement.find("li")
     
      sc=getScopeVariableName()
        
      return ($scope,iElement,iAttrs,controller)->
        return
          
  }
  return directiveDefinitionObject    
  
###

          <mp-dropdown-content dropdown-title="Partials Content" dropdown-list="Roles" dropdown-src="'/Partials/View1.html'" dropdown-content-class="f-dropdown content medium" dropdown-split-button  dropdown-button-class="button split" dropdown-split-button></mp-dropdown-content>
###

mpdropdownContentDirective = ($parse,$compile,$timeout)->

  type = (obj) ->
    if obj == undefined or obj == null
      return String obj
    classToType = {
      '[object Boolean]': 'boolean',
      '[object Number]': 'number',
      '[object String]': 'string',
      '[object Function]': 'function',
      '[object Array]': 'array',
      '[object Date]': 'date',
      '[object RegExp]': 'regexp',
      '[object Object]': 'object'
    }
    return classToType[Object.prototype.toString.call(obj)]
   
  randomString = (length, chars)->
    i = length
    result=''
    while i > 0
      result += chars[Math.round(Math.random()*(chars.length-1))]
      --i
    return result
  
  getRandomName = (prefix)->
    p1=randomString 28, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    p2=randomString 4, '0123456789'
    newname=prefix+p1+p2
    return newname
  selectItem = ()->
    i=0
    return 
  hashKey = (obj)->
    i=0
    return  
  directiveDefinitionObject = {
    scope: {
        dropdownSrc: '@'
        dropdownTitle: '@'
        dropdownButtonClass: '@'
        dropdownSplitButton: '='
        dropdownContentClass: '@'
               
    }
    priority: 0
    
    replace: true
    trsnaclude: false
    restrict: 'AE'
    controller: [
      "$scope"
      "$element"
      "$attrs"
      "$transclude"
      "$timeout"
      ($scope,$element,$attrs,$transclude,$timeout)->
        uniqAId=getRandomName("dropdown_")
        if $scope.dropdownButtonClass
          buttonClass=$scope.dropdownButtonClass
        else
          buttonClass="button" 
        if $scope.dropdownContentClass?
          contentClass=$scope.dropdownContentClass
        else
          contentClass="f-dropdown content medium"
        stemplate1=''
        if $attrs.dropdownSplitButton?
          stemplate1= '<div>'+'<a ng-href="" data-dropdown="{0}" class="{1}">{2}<span></span></a>'
        else  
          stemplate1= '<div>'+'<a ng-href="" data-dropdown="{0}" class="{1}">{2}</a>'
        stemplate1=stemplate1.replace("{0}",uniqAId)
        stemplate1=stemplate1.replace("{1}",buttonClass)        
        stemplate1=stemplate1.replace("{2}",$scope.dropdownTitle)
        stemplate2='<div id="{0}" class="{1}" data-dropdown-content>'
        stemplate2=stemplate2.replace("{0}",uniqAId)
        stemplate2=stemplate2.replace("{1}",contentClass)
          
        stemplate3='<ng-include src="{0}"><ng-include>'
        stemplate4='</div>'
        stemplate=""
        value=$scope.dropdownSrc
        stemplate3=stemplate3.replace("{0}",value)
        stemplate=stemplate1+stemplate2+stemplate3+stemplate4
        $element.append($compile(stemplate)($scope))    
        $scope.selectItem = (self,idx)->
          return
          #self1=self
          #i=idx
          #if !this.dropdownList.$resolved
          #  this.dropdownList.$promise.then (value)->
          #    this.dropdownModel=value[idx]
              
          #else
          #  this.dropdownModel=this.dropdownList[idx]
           
            
          #return    

      
        return 
    ]
    link: (scope, iElement, iAttrs,$timeout)=>
          
      return ($scope,iElement,iAttrs,controller)->
        return
        
  }
  return directiveDefinitionObject    

myF4_DirectiveApp.directive 'mpDropdown', mpdropdownDirective
myF4_DirectiveApp.directive 'mpDropdownContent', mpdropdownContentDirective
