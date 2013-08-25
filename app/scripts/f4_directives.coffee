'use strict'

myF4_DirectiveApp=angular.module('myF4DirectiveApp',[])

#Register Hellper Functions
myF4_DirectiveApp.factory "mpF4Helper", [() ->
  type:  (obj) ->
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
  
  randomString: (length, chars)->
    i = length
    result=''
    while i > 0
      result += chars[Math.round(Math.random()*(chars.length-1))]
      --i
    return result
  
  getRandomName:  (prefix)->
    p1=@randomString 28, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    p2=@randomString 4, '0123456789'
    newname=prefix+p1+p2
    return newname
 ]
  
### Example
  <mp-dropdown dropdown-title="Roles" dropdown-list="Roles" dropdown-model="User.user_data.role_row" dropdown-var="va" dropdown-split-button dropdown-repeat-text="va.role_data.role" dropdown-button-class="button split" dropdown-split-button></mp-dropdown>
   
   where dropdown-list is a scope variable array, dropdown-model is a element of the array     
###
mpdropdownDirective = ($parse,$compile,$timeout)->

  
  valueIdentifier = null
  keyIdentifier  = null
  scopeVariableName = null
   
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
      "mpF4Helper"
      ($scope,$element,$attrs,$transclude,$timeout,mpF4Helper)->
        setValueIdentifier($attrs.dropdownVar)
        setScopeVariableName($attrs.dropdownList)
        uniqAId=mpF4Helper.getRandomName("dropdown_")
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
        
        makeTemplate = (value)->
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
        
        
        stemplate=""
        resolvedType=mpF4Helper.type($scope.dropdownList.$resolved)
        if resolvedType != "undefined" and $scope.dropdownList.$resolved==false
          $scope.dropdownList.$promise.then (value)->
            makeTemplate(value)  
        else
          value=$scope.dropdownList
          makeTemplate(value)  
            
        $scope.selectItem = (self,idx)->
          self1=self
          i=idx
          resolvedType=mpF4Helper.type(this.dropdownList.$resolved)
          if resolvedType != "undefined" and this.dropdownList.$resolved==false
            this.dropdownList.$promise.then (value)->
              this.dropdownModel=value[idx]
              
          else
            this.dropdownModel=this.dropdownList[idx]
           
            
          return    

      
        return 
    ]
    link: (scope, iElement, iAttrs,$timeout)->
      return ($scope,iElement,iAttrs,controller)->
        return
          
  }
  return directiveDefinitionObject    
  
###

          <mp-dropdown-content dropdown-title="Partials Content" dropdown-list="Roles" dropdown-src="'/Partials/View1.html'" dropdown-content-class="f-dropdown content medium" dropdown-split-button  dropdown-button-class="button split" dropdown-split-button></mp-dropdown-content>
###

mpdropdownContentDirective = ($parse,$compile,$timeout)->
 
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
      "mpF4Helper"
      ($scope,$element,$attrs,$transclude,$timeout,mpF4Helper)->
        
        uniqAId=mpF4Helper.getRandomName("dropdown_")
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
     
      
        return 
    ]
    link: (scope, iElement, iAttrs,$timeout)->
          
      return ($scope,iElement,iAttrs,controller)->
        return
        
  }
  return directiveDefinitionObject    
###
mpClearing

###
mpclearingDirective = ($parse,$compile,$timeout)->
  directiveDefinitionObject = {
    scope: {
        clearingClass: '@'
        clearingImageList: '='
        clearingImageDir: '@'
        clearingThumbDir: '@'       
    }
    priority: 1000
    
    replace: true
    trsnaclude: false
    restrict: 'AE'
    controller: [
      "$scope"
      "$element"
      "$attrs"
      "$transclude"
      "$timeout"
      "mpF4Helper"
      ($scope,$element,$attrs,$transclude,$timeout,mpF4Helper)->
        uniqAId=mpF4Helper.getRandomName("clearing_")
        divUId = mpF4Helper.getRandomName("clearingdiv_")
        if $scope.clearingClass
          clearingClass=$scope.clearingClass
        else
          clearingClass="clearing-thumbs"
        
    
        
        imageDir="pictures/"
        if $scope.clearingImageDir
          imageDir=$scope.clearingImageDir
        thumbDir="pictures/"
        if $scope.clearingThumbDir
          thumbDir=$scope.clearingThumbDir
           
     
      
        
        makeTemplate= (uid,value,breplace)->
          iLength=value.length
          i=0
          bFeatured=false
          smiddle=""
          smodel='<li {0}><a href="{1}"><img src="{2}" {3}/></a></li>'
          while i<iLength
            iItem=value[i]
            featured=""
            caption=""
            if iItem.featured
              bFeatured=true
              featured='class="clearing-featured-img"'
            smiddle=smiddle+smodel.replace("{0}",featured)
            smiddle=smiddle.replace("{1}",imageDir+iItem.imageSrc)
            smiddle=smiddle.replace("{2}",thumbDir+iItem.imageThSrc)  
            captionType=mpF4Helper.type(iItem.caption)
            if captionType == "string" and iItem.caption!=""
              caption='data-caption="'+iItem.caption+'"'
            smiddle=smiddle.replace("{3}",caption) 
            ++i
          if bFeatured
            clearingClass = clearingClass + ' ' + 'clearing-feature'
          stemplatepre='<ul class="' + clearingClass+'" data-clearing="'+uid+'">'+smiddle+'</ul>'
          stemplate='<div id="' + divUId + '">' + stemplatepre + '</div>'
          if !breplace  
            $element.append($compile(stemplate)($scope))
          else
            $element.find('div').remove()
            $element.append($compile(stemplatepre)($scope))
                
        listType=mpF4Helper.type($scope.clearingImageList)
        if listType == "undefined"
          imageListType="undefined"
        else
          imageListType=mpF4Helper.type($scope.clearingImageList.$resolved)
        if  imageListType != "undefined" and $scope.clearingImageList.$resolved==false
          $scope.clearingImageList.$promise.then (value)->
            makeTemplate(uniqAId,value,false)
        else
          value=$scope.clearingImageList
          makeTemplate(uniqAId,value,false) if value
        $scope.$watch "clearingImageList", (newValue,oldValue)->
          if newValue != oldValue
            #$element.remove()
            uniqAId=mpF4Helper.getRandomName("clearing_")
      
            makeTemplate(uniqAId,newValue,true) 
            setTimeout ()->
                $(document).foundation('clearing')
             ,0
   
        
         
    ]
    link: (scope, iElement, iAttrs,$timeout)->
      setTimeout ()->
        $(document).foundation('clearing')
      ,0
   
      return ($scope,iElement,iAttrs,controller)->
        return
        
  }
  return directiveDefinitionObject    

###
mpAlertBox

###
mpalertBoxesDirective = ($parse,$compile,$timeout)->
  directiveDefinitionObject = {
    scope: {
        alertClass: '@'
        alertContent: '@'
        alertCloseClass: '@'
        alertCloseSymbol: '@'       
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
      "mpF4Helper"
      ($scope,$element,$attrs,$transclude,$timeout,mpF4Helper)->
        uniqAId=mpF4Helper.getRandomName("clearing_")
        divUId = mpF4Helper.getRandomName("clearingdiv_")
        if $scope.alertClass
          alertClass=$scope.alertClass
        else
          alertClass="alert-box"
        if $scope.alertCloseClass
          alertCloseClass=$scope.alertCloseClass
        else
          alertCloseClass="close"
        if $scope.alertCloseSymbol
          alertCloseSymbol=$scope.alertCloseSymbol
        else
          alertCloseSymbol="&times;"
     
      
        
        makeTemplate= (uid,value,breplace)->
          stemplate1="<div>"
          stemplate2='<div data-alert class="' + alertClass + '">';
          smiddle=value  
          stemplate3='<a href="" class="' + alertCloseClass + '">' + alertCloseSymbol + '</a></div>'
          stemplate4="</div>"
          if !breplace
            stemplate=stemplate1+stemplate2+smiddle+stemplate3+stemplate4
            $element.append($compile(stemplate)($scope))
          else
            stemplate=stemplate2+smiddle+stemplate3
            $element.find('div').remove()
            $element.append($compile(stemplate)($scope))
            
                           
        contentType=mpF4Helper.type($scope.alertContent)
        if contentType != "undefined"
          contentTypeResolved=mpF4Helper.type($scope.alertContent.$resolved)
          
        if  contentTypeResolved != "undefined" and $scope.contentType.$resolved==false
          $scope.alertContent.$promise.then (value)->
            makeTemplate(uniqAId,value,false)
        else
          value=$scope.alertContent
          makeTemplate(uniqAId,value,false) if value
        $scope.$watch "clearingImageList", (newValue,oldValue)->
          if newValue != oldValue
            #$element.remove()
            uniqAId=mpF4Helper.getRandomName("alertbox_")
      
            makeTemplate(uniqAId,newValue,true) 
            setTimeout ()->
                $(document).foundation('alerts')
             ,0
   
        
         
    ]
    link: (scope, iElement, iAttrs,$timeout)->
      setTimeout ()->
        $(document).foundation('alerts')
      ,0
   
      return ($scope,iElement,iAttrs,controller)->
        return
        
  }
  return directiveDefinitionObject    


###
mpAlertBox

###
mpsectionDirective = ($parse,$compile,$timeout)->
  directiveDefinitionObject = {
    scope: {
        sectionTitleClass: '@'
        sectionTitle: '@'
        sectionContentClass: '@'
        sectionHref: '@'
        sectionContent: '@'
        sectionIncludeSrc: '@'    
        sectionRepeat: '@'   
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
      "mpF4Helper"
      ($scope,$element,$attrs,$transclude,$timeout,mpF4Helper)->
        uniqAId=mpF4Helper.getRandomName("clearing_")
        divUId = mpF4Helper.getRandomName("clearingdiv_")
        if $scope.sectionTitleClass
          sectionTitleClass=$scope.sectionTitleClass
        else
          sectionTitleClass="title"
        if $scope.sectionTitle
          sectionTitle=$scope.sectionTitle
        else
          sectionTitle="Section Title"
        if $scope.sectionContentClass
          sectionContentClass=$scope.sectionContentClass
        else
          sectionContentClass="content"
        if $scope.sectionHref
          sectionHref=$scope.sectionHref
        else
          sectionHref=""
        if $scope.sectionContent
          sectionContent=$scope.sectionContent
        else
          sectionContent="<p>Section Content</p>"
        
        if $scope.sectionIncludeSrc
          sectionIncludeSrc=$scope.sectionIncludeSrc
        else
          sectionIncludeSrc=""
      
      
        
        makeTemplate= (uid,value,breplace)->
          stemplate1="<div>"
          stemplate2="<section>"
          stemplate3='<p class="' + sectionTitleClass + 
            '" data-section-title><a href="' + sectionHref + '">' + sectionTitle + '</a></p>';
          if sectionIncludeSrc != ""
            sectionContent='<ng-include src="' + sectionIncludeSrc + '"></ng-include>'  
          stemplate4='<div class="' + sectionContentClass + '" data-section-content>' + sectionContent + '</div>'  
          stemplate5="</section>"
          stemplate6="</div>"
          if !breplace
            stemplate=stemplate1+stemplate2+stemplate3+stemplate4+stemplate5+stemplate6
            #stemplate=stemplate2+stemplate3+stemplate4+stemplate5
            $element.append($compile(stemplate)($scope))
          else
            stemplate=stemplate2+smiddle+stemplate3+stemplate4+stemplate5
            $element.find('div').remove()
            #$element.remove()
            $element.append($compile(stemplate)($scope))
            
        makeTemplate(uniqAId,null,false)
        $scope.$watch "sectionContent", (newValue,oldValue)->
          if newValue != oldValue
            #$element.remove()
            uniqAId=mpF4Helper.getRandomName("section_")
      
            makeTemplate(uniqAId,newValue,true) 
            setTimeout ()->
                $(document).foundation('section')
             ,0
   
        
         
    ]
    link: (scope, iElement, iAttrs,$timeout)->
      setTimeout ()->
        $(document).foundation('section')
      ,0
   
      return ($scope,iElement,iAttrs,controller)->
        return
        
  }
  return directiveDefinitionObject    

myF4_DirectiveApp.directive 'mpDropdown', mpdropdownDirective
myF4_DirectiveApp.directive 'mpDropdownContent', mpdropdownContentDirective
myF4_DirectiveApp.directive 'mpClearing', mpclearingDirective
myF4_DirectiveApp.directive 'mpAlertBox', mpalertBoxesDirective
myF4_DirectiveApp.directive 'mpSection', mpsectionDirective
