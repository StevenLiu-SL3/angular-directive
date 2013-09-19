"use strict"

myF4_DirectiveApp = angular.module("myF4DirectiveApp", [])
myF4_DirectiveApp.factory "mpF4Helper", [->
  type: (obj) ->
    return String(obj)  if obj is undefined or obj is null
    classToType =
      "[object Boolean]": "boolean"
      "[object Number]": "number"
      "[object String]": "string"
      "[object Function]": "function"
      "[object Array]": "array"
      "[object Date]": "date"
      "[object RegExp]": "regexp"
      "[object Object]": "object"

    classToType[Object::toString.call(obj)]

  randomString: (length, chars) ->
    i = length
    result = ""
    while i > 0
      result += chars[Math.round(Math.random() * (chars.length - 1))]
      --i
    result

  getRandomName: (prefix) ->
  
    p1 = @randomString(28, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    p2 = @randomString(4, "0123456789")
    newname = prefix + p1 + p2
    newname

  clone: (obj) ->
   
    return obj  if (not (obj?)) or typeof obj isnt "object"
    return new Date(obj.getTime())  if obj instanceof Date
    if obj instanceof RegExp
      flags = ""
      flags += "g"  if obj.global?
      flags += "i"  if obj.ignoreCase?
      flags += "m"  if obj.multiline?
      flags += "y"  if obj.sticky?
      return new RegExp(obj.source, flags)
    newInstance = new obj.constructor()
    for key of obj
      newInstance[key] = @clone(obj[key])
    newInstance

  cloneAttributes: (obj) ->
  
    return obj  if (not (obj?)) or typeof obj isnt "object"
    return new Date(obj.getTime())  if obj instanceof Date
    if obj instanceof RegExp
      flags = ""
      flags += "g"  if obj.global?
      flags += "i"  if obj.ignoreCase?
      flags += "m"  if obj.multiline?
      flags += "y"  if obj.sticky?
      return new RegExp(obj.source, flags)
    bOk = true
    newInstance = null
    try
      newInstance = new obj.constructor()
    catch _error
      bOk = false
      return null
    for key of obj
      inst = @cloneAttributes(obj[key])
      newInstance[key] = inst  if inst
    newInstance
]
myF4_DirectiveApp.service "radioGlobalService", ["mpF4Helper", (mpF4Helper) ->
  @radioGlobal = new Array()  if mpF4Helper.type(@radioGlalbal) is "undefined"
  @registerRadio = (scope, element, attrs, transclude) ->
   
    if mpF4Helper.type(attrs.id) isnt "undefined"
      id = attrs.id
      obj = @radioGlobal[id]
      @radioGlobal[id] = new Array()  if mpF4Helper.type(obj) is "undefined"
      obj = @radioGlobal[id]
      if mpF4Helper.type(obj) is "array"
        iLen = obj.length
        obj[iLen] = element

  @getRadios = (id) ->
    @radioGlobal[id]
]

# Example
#    <mp-dropdown dropdown-title="Roles" dropdown-list="Roles" dropdown-model="User.user_data.role_row" dropdown-var="va" dropdown-split-button dropdown-repeat-text="va.role_data.role" dropdown-button-class="button split" dropdown-split-button></mp-dropdown>
#     
#     where dropdown-list is a scope variable array, dropdown-model is a element of the array
#  
mpdropdownDirective = ($parse, $compile, $timeout) ->
 
  valueIdentifier = null
  keyIdentifier = null
  scopeVariableName = null
  setValueIdentifier = (vi) ->
    valueIdentifier = vi

  getValueIdentifier = ->
    valueIdentifier

  setKeyIdentifier = (vi) ->
    keyIdentifier = vi

  getKeyIdentifier = ->
    keyIdentifier

  setScopeVariableName = (sv) ->
    scopeVariableName = sv

  getScopeVariableName = ->
    scopeVariableName

  directiveDefinitionObject =
    scope:
      dropdownModel: "="
      dropdownRepeat: "@"
      dropdownRepeatText: "="
      dropdownTitle: "@"
      dropdownList: "="
      dropdownVar: "@"
      dropdownButtonClass: "@"
      dropdownSplitButton: "="
      tipTitle: '@'
      tipClass: '@'

    priority: 0
    
    #
    #      template: '<div>'+
    #                '<a ng-href="" data-dropdown="drop1">Has dropdown</a>'+
    #                '<ul id="drop1" class="f-dropdown" data-dropdown-content>'+     
    #                '<li ><a data-ng-href="selectItem(this,idx)" data-ng-click="selectItem(this)"></a></li>'+
    #                '</ul>'+
    #                '</div>'
    #      
    replace: true
    trsnaclude: false
    restrict: "AE"
    controller: ["$scope", "$element", "$attrs", "$transclude", "$timeout", "mpF4Helper", ($scope, $element, $attrs, $transclude, $timeout, mpF4Helper) ->
    
      setValueIdentifier $attrs.dropdownVar
      setScopeVariableName $attrs.dropdownList
      uniqAId = mpF4Helper.getRandomName("dropdown_")
      if angular.isUndefined($scope.tipTitle)
        tipTitle=""
      else
        tipTitle=$scope.tipTitle
      if angular.isUndefined($scope.tipClass)
        tipClass="has-tip"
      else
        tipClass=$scope.tipClass


      if $scope.dropdownButtonClass
        buttonClass = $scope.dropdownButtonClass
      else
        buttonClass = "button dropdown"
      if tipTitle != ""
        buttonClass=buttonClass + " " + tipClass

      stemplate1 = ""
      if $attrs.dropdownSplitButton?
        stemplate1 = "<div>"
        stemplate1 = stemplate1 + "<a ng-href=\"\" data-dropdown=\"{0}\" class=\"{1}\" {3}>{2}<span data-dropdown=\"{0}\"></span></a>"
      else        
        stemplate1 = "<div>"
        stemplate1 = stemplate1 + "<a ng-href=\"\" data-dropdown=\"{0}\" class=\"{1}\" {3}>{2}</a>"
      stemplate1 = stemplate1.replace("{0}", uniqAId)
      stemplate1 = stemplate1.replace("{0}", uniqAId)
      stemplate1 = stemplate1.replace("{1}", buttonClass)
      stemplate1 = stemplate1.replace("{2}", $scope.dropdownTitle)
      if tipTitle!=""
        stemplate1 = stemplate1.replace("{3}",'title="' + tipTitle + '"')
      else
        stemplate1 = stemplate1.replace("{3}",'')
      stemplate2 = "<ul id=\"{0}\" class=\"f-dropdown\" data-dropdown-content>"
      stemplate2 = stemplate2.replace("{0}", uniqAId)
      stemplate3 = "<li ><a data-ng-click=\"{0}\">{1}</a></li>"
      stemplate4 = "</ul>" + "</div>"
      makeTemplate = (value) ->
        i = 0
        iLength = value.length
        smiddle = ""
        while i < iLength
          v = value[i]
          vi = getValueIdentifier()
          tempObj = new Object()
          vaGetter = $parse(vi)
          vaSetter = vaGetter.assign
          vaSetter tempObj, v
          vaTextGetter = $parse($attrs.dropdownRepeatText)
          txt = vaTextGetter(tempObj)
          fnName = "selectItem(this," + i + ")"
          smiddle1 = stemplate3.replace("{0}", fnName)
          smiddle2 = smiddle1.replace("{0}", fnName)
          smiddle3 = smiddle2.replace("{1}", txt)
          smiddle = smiddle + smiddle3
          i++
        stemplate = stemplate1 + stemplate2 + smiddle + stemplate4
        $element.append $compile(stemplate)($scope)

      stemplate = ""
      resolvedType = mpF4Helper.type($scope.dropdownList.$resolved)
      if resolvedType isnt "undefined" and $scope.dropdownList.$resolved is false
        $scope.dropdownList.$promise.then (value) ->
          makeTemplate value

      else
        value = $scope.dropdownList
        makeTemplate value
      $scope.selectItem = (self, idx) ->
        self1 = self
        i = idx
        resolvedType = mpF4Helper.type(@dropdownList.$resolved)
        if resolvedType isnt "undefined" and @dropdownList.$resolved is false
          @dropdownList.$promise.then (value) ->
            @dropdownModel = value[idx]

        else
          @dropdownModel = @dropdownList[idx]
    ]
    link: (scope, iElement, iAttrs, $timeout) ->
      ($scope, iElement, iAttrs, controller) ->

  directiveDefinitionObject


#
#  
#            <mp-dropdown-content dropdown-title="Partials Content" dropdown-list="Roles" dropdown-src="'/Partials/View1.html'" dropdown-content-class="f-dropdown content medium" dropdown-split-button  dropdown-button-class="button split" dropdown-split-button></mp-dropdown-content>
#  
mpdropdownContentDirective = ($parse, $compile, $timeout) ->
  directiveDefinitionObject =
    scope:
      dropdownSrc: "@"
      dropdownTitle: "@"
      dropdownButtonClass: "@"
      dropdownSplitButton: "="
      dropdownContentClass: "@"
      tipClass: "@"
      tipTitle: "@"
    priority: 0
    replace: true
    trsnaclude: false
    restrict: "AE"
    controller: ["$scope", "$element", "$attrs", "$transclude", "$timeout", "mpF4Helper", ($scope, $element, $attrs, $transclude, $timeout, mpF4Helper) ->
      uniqAId = mpF4Helper.getRandomName("dropdown_")

      if angular.isUndefined($scope.tipTitle)
        tipTitle=""
      else
        tipTitle=$scope.tipTitle
      if angular.isUndefined($scope.tipClass)
        tipClass="has-tip"
      else
        tipClass=$scope.tipClass


      if $scope.dropdownButtonClass
        buttonClass = $scope.dropdownButtonClass
      else
        buttonClass = "button"

      if tipTitle != ""
        butonClass = buttonClass + " " + tipClass

      if $scope.dropdownContentClass?
        contentClass = $scope.dropdownContentClass
      else
        contentClass = "f-dropdown content medium"
      stemplate1 = ""
      if $attrs.dropdownSplitButton?
        stemplate1 = "<div>" + "<a ng-href=\"\" data-dropdown=\"{0}\" class=\"{1}\" {3}>{2}<span></span></a>"
      else
        stemplate1 = "<div>" + "<a ng-href=\"\" data-dropdown=\"{0}\" class=\"{1}\" {3}>{2}</a>"
      stemplate1 = stemplate1.replace("{0}", uniqAId)
      stemplate1 = stemplate1.replace("{1}", buttonClass)
      stemplate1 = stemplate1.replace("{2}", $scope.dropdownTitle)
      if tipTitle!=""
        stemplate1 = stemplate1.replace("{3}",'title="' + tipTitle + '"')
      else
        stemplate1 = stemplate1.replace("{3}","")
      stemplate2 = "<div id=\"{0}\" class=\"{1}\" data-dropdown-content>"
      stemplate2 = stemplate2.replace("{0}", uniqAId)
      stemplate2 = stemplate2.replace("{1}", contentClass)
      stemplate3 = "<ng-include src=\"{0}\"><ng-include>"
      stemplate4 = "</div>"
      stemplate = ""
      value = $scope.dropdownSrc
      stemplate3 = stemplate3.replace("{0}", value)
      stemplate = stemplate1 + stemplate2 + stemplate3 + stemplate4
      $element.append $compile(stemplate)($scope)
      $scope.selectItem = (self, idx) ->
    ]
    link: (scope, iElement, iAttrs, $timeout) ->
      ($scope, iElement, iAttrs, controller) ->

  directiveDefinitionObject


#
#  mpClearing
#  
mpclearingDirective = ($parse, $compile, $timeout) ->
  directiveDefinitionObject =
    scope:
      clearingClass: "@"
      clearingImageList: "="
      clearingImageDir: "@"
      clearingThumbDir: "@"

    priority: 1000
    replace: true
    trsnaclude: false
    restrict: "AE"
    controller: ["$scope", "$element", "$attrs", "$transclude", "$timeout", "mpF4Helper", ($scope, $element, $attrs, $transclude, $timeout, mpF4Helper) ->
      uniqAId = mpF4Helper.getRandomName("clearing_")
      divUId = mpF4Helper.getRandomName("clearingdiv_")
      if $scope.clearingClass
        clearingClass = $scope.clearingClass
      else
        clearingClass = "clearing-thumbs"
      imageDir = "pictures/"
      imageDir = $scope.clearingImageDir  if $scope.clearingImageDir
      thumbDir = "pictures/"
      thumbDir = $scope.clearingThumbDir  if $scope.clearingThumbDir
      makeTemplate = (uid, value, breplace) ->
        iLength = value.length
        i = 0
        bFeatured = false
        smiddle = ""
        smodel = "<li {0}><a href=\"{1}\"><img src=\"{2}\" {3}/></a></li>"
        while i < iLength
          iItem = value[i]
          featured = ""
          caption = ""
          if iItem.featured
            bFeatured = true
            featured = "class=\"clearing-featured-img\""
          smiddle = smiddle + smodel.replace("{0}", featured)
          smiddle = smiddle.replace("{1}", imageDir + iItem.imageSrc)
          smiddle = smiddle.replace("{2}", thumbDir + iItem.imageThSrc)
          captionType = mpF4Helper.type(iItem.caption)
          caption = "data-caption=\"" + iItem.caption + "\""  if captionType is "string" and iItem.caption isnt ""
          smiddle = smiddle.replace("{3}", caption)
          ++i
        clearingClass = clearingClass + " " + "clearing-feature"  if bFeatured
        stemplatepre = "<ul class=\"" + clearingClass + "\" data-clearing=\"" + uid + "\">" + smiddle + "</ul>"
        stemplate = "<div id=\"" + divUId + "\">" + stemplatepre + "</div>"
        unless breplace
          $element.append $compile(stemplate)($scope)
        else
          $element.find("div").remove()
          $element.append $compile(stemplatepre)($scope)

      listType = mpF4Helper.type($scope.clearingImageList)
      if listType is "undefined"
        imageListType = "undefined"
      else
        imageListType = mpF4Helper.type($scope.clearingImageList.$resolved)
      if imageListType isnt "undefined" and $scope.clearingImageList.$resolved is false
        $scope.clearingImageList.$promise.then (value) ->
          makeTemplate uniqAId, value, false

      else
        value = $scope.clearingImageList
        makeTemplate uniqAId, value, false  if value
      $scope.$watch "clearingImageList", (newValue, oldValue) ->
        if newValue isnt oldValue
          uniqAId = mpF4Helper.getRandomName("clearing_")
          makeTemplate uniqAId, newValue, true
          setTimeout (->
            $(document).foundation "clearing"
          ), 0

    ]
    link: (scope, iElement, iAttrs, $timeout) ->
      setTimeout (->
        $(document).foundation "clearing"
      ), 0
      ($scope, iElement, iAttrs, controller) ->

  directiveDefinitionObject


#
#  mpAlertBox
#  
mpalertBoxesDirective = ($parse, $compile, $timeout) ->
  directiveDefinitionObject =
    scope:
      alertClass: "@"
      alertContent: "@"
      alertCloseClass: "@"
      alertCloseSymbol: "@"

    priority: 1000
    replace: true
    trsnaclude: false
    restrict: "AE"
    controller: ["$scope", "$element", "$attrs", "$transclude", "$timeout", "mpF4Helper", ($scope, $element, $attrs, $transclude, $timeout, mpF4Helper) ->
      uniqAId = mpF4Helper.getRandomName("clearing_")
      divUId = mpF4Helper.getRandomName("clearingdiv_")
      if $scope.alertClass
        alertClass = $scope.alertClass
      else
        alertClass = "alert-box"
      if $scope.alertCloseClass
        alertCloseClass = $scope.alertCloseClass
      else
        alertCloseClass = "close"
      if $scope.alertCloseSymbol
        alertCloseSymbol = $scope.alertCloseSymbol
      else
        alertCloseSymbol = "&times;"
      makeTemplate = (uid, value, breplace) ->
        stemplate1 = "<div>"
        stemplate2 = "<div data-alert class=\"" + alertClass + "\">"
        smiddle = value
        stemplate3 = "<a href=\"\" class=\"" + alertCloseClass + "\">" + alertCloseSymbol + "</a></div>"
        stemplate4 = "</div>"
        unless breplace
          stemplate = stemplate1 + stemplate2 + smiddle + stemplate3 + stemplate4
          $element.append $compile(stemplate)($scope)
        else
          stemplate = stemplate2 + smiddle + stemplate3
          $element.find("div").remove()
          $element.append $compile(stemplate)($scope)

      contentType = mpF4Helper.type($scope.alertContent)
      contentTypeResolved = mpF4Helper.type($scope.alertContent.$resolved)  if contentType isnt "undefined"
      if contentTypeResolved isnt "undefined" and $scope.contentType.$resolved is false
        $scope.alertContent.$promise.then (value) ->
          makeTemplate uniqAId, value, false

      else
        value = $scope.alertContent
        makeTemplate uniqAId, value, false  if value
      $scope.$watch "clearingImageList", (newValue, oldValue) ->
        if newValue isnt oldValue
          uniqAId = mpF4Helper.getRandomName("alertbox_")
          makeTemplate uniqAId, newValue, true
          setTimeout (->
            $(document).foundation "alerts"
          ), 0

    ]
    link: (scope, iElement, iAttrs, $timeout) ->
      setTimeout (->
        $(document).foundation "alerts"
      ), 0
      ($scope, iElement, iAttrs, controller) ->

  directiveDefinitionObject


#
#  mpSection
#  
mpsectionDirective = ($parse, $compile, $timeout) ->
  directiveDefinitionObject =
    scope:
      sectionTitleClass: "@"
      sectionTitle: "@"
      sectionContentClass: "@"
      sectionHref: "@"
      sectionContent: "@"
      sectionIncludeSrc: "@"
      sectionRepeat: "@"

    priority: 1000
    replace: true
    transclude: false
    restrict: "A"
    controller: ["$scope", "$element", "$attrs", "$transclude", "$timeout", "mpF4Helper", ($scope, $element, $attrs, $transclude, $timeout, mpF4Helper) ->
      uniqAId = mpF4Helper.getRandomName("clearing_")
      divUId = mpF4Helper.getRandomName("clearingdiv_")
      if $scope.sectionTitleClass
        sectionTitleClass = $scope.sectionTitleClass
      else
        sectionTitleClass = "title"
      if $scope.sectionTitle
        sectionTitle = $scope.sectionTitle
      else
        sectionTitle = "Section Title"
      if $scope.sectionContentClass
        sectionContentClass = $scope.sectionContentClass
      else
        sectionContentClass = "content"
      if $scope.sectionHref
        sectionHref = $scope.sectionHref
      else
        sectionHref = ""
      if $scope.sectionContent
        sectionContent = $scope.sectionContent
      else
        sectionContent = "<p>Section Content</p>"
      if $scope.sectionIncludeSrc
        sectionIncludeSrc = $scope.sectionIncludeSrc
      else
        sectionIncludeSrc = ""
      makeTemplate = (uid, value, breplace) ->
        stemplate1 = "<div>"
        stemplate2 = "<section>"
        stemplate3 = "<p class=\"" + sectionTitleClass + "\" data-section-title><a href=\"" + sectionHref + "\">" + sectionTitle + "</a></p>"
        sectionContent = "<ng-include src=\"" + sectionIncludeSrc + "\"></ng-include>"  if sectionIncludeSrc isnt ""
        stemplate4 = "<div class=\"" + sectionContentClass + "\" data-section-content>" + sectionContent + "</div>"
        stemplate5 = "</section>"
        stemplate6 = "</div>"
        unless breplace
          stemplate = stemplate1 + stemplate2 + stemplate3 + stemplate4 + stemplate5 + stemplate6
          $element.append $compile(stemplate)($scope)
        else
          stemplate = stemplate2 + stemplate3 + stemplate4 + stemplate5
          $element.find("div").remove()
          $element.append $compile(stemplate)($scope)

      makeTemplate uniqAId, null, false
      $scope.$watch "sectionContent", (newValue, oldValue) ->
        if newValue isnt oldValue
          uniqAId = mpF4Helper.getRandomName("section_")
          makeTemplate uniqAId, newValue, true
          setTimeout (->
            $(document).foundation "section"
          ), 0

    ]
    link: (scope, iElement, iAttrs, $timeout) ->
      setTimeout (->
        $(document).foundation "section"
      ), 0
      ($scope, iElement, iAttrs, controller) ->

  directiveDefinitionObject


#
#  mpSectionContainer
#  sectionList must be in the following format and the first three items must be present
#  [{title:"",content:"",src:'',include:false,titleClass:"",contentClass:"",href:""}]
#  when include is true src would be the url point to a partial html file
#  
mpsectionContainerDirective = ($parse, $compile, $timeout) ->

  directiveDefinitionObject =
    scope:
      containerClass: "@"
      containerDataSection: "@"
      containerDataOption: "@"
      sectionList: "="

    priority: 1000
    replace: true
    transclude: true
    restrict: "AE"
    controller: ["$scope", "$element", "$attrs", "$transclude", "$timeout", "mpF4Helper", ($scope, $element, $attrs, $transclude, $timeout, mpF4Helper) ->
      uniqAId = mpF4Helper.getRandomName("clearing_")
      divUId = mpF4Helper.getRandomName("clearingdiv_")
      if $scope.containerClass
        containerClass = $scope.containerClass
      else
        containerClass = "section-container auto"
      if $scope.containerDataSection
        containerDataSection = $scope.containerDataSection
      else
        containerDataSection = ""
      if $scope.containerDataOption
        containerDataOption = $scope.containerDataOption
      else
        containerDataOption = ""
      if $scope.sectionList
        sectionList = $scope.sectionList
      else
        return
      setSectionDefault = (oItem) ->
        item = angular.copy(oItem)
        item.include = false  if angular.isUndefined(item.include)
        item.content = ""  if angular.isUndefined(item.content)
        item.src = ""  if angular.isUndefined(item.src)
        item.titleClass = ""  if angular.isUndefined(item.titleClass)
        item.titleClass = "title"  if item.titleClass is ""
        item.title = ""  if angular.isUndefined(item.title)
        item.title = "Section"  if item.title is ""
        item.contentClass = ""  if angular.isUndefined(item.conten)
        item.contentClass = "content"  if item.contentClass is ""
        item

      makeSection = (item) ->
        sline1 = "<section>"
        sline2 = "<p calss=\"{0}\" data-section-title><a href=\"{1}\">{2}</a></p>"
        sline3 = "<div class=\"{3}\" data-section-content>{4}</div>"
        sline4 = "</section>"
        sline2 = sline2.replace("{0}", item.titleClass)
        sline2 = sline2.replace("{1}", item.href)
        sline2 = sline2.replace("{2}", item.title)
        sline3 = sline3.replace("{3}", item.contentClass)
        if item.include
          sline3 = sline3.replace("{4}", "<ng-include src=\"" + item.src + "\"/>")
        else
          sline3 = sline3.replace("{4}", item.content)
        sline1 + sline2 + sline3 + sline4

      makeTemplate = (secList, inclusive) ->
        sectionListType = mpF4Helper.type(secList)
        if sectionListType is "array"
          iLen = secList.length
          i = 0
          sline = ""
          while i < iLen
            item = setSectionDefault(secList[i])
            sline = sline + makeSection(item)
            ++i
          return sline  if inclusive is false
          stemplate1 = "<div class=\"{0}\" data-section=\"{1}\" data-options=\"{2}\">            {3}</div>"
          stemplate1 = stemplate1.replace("{0}", containerClass)
          stemplate1 = stemplate1.replace("{1}", containerDataSection)
          stemplate1 = stemplate1.replace("{2}", containerDataOption)
          stemplate1 = stemplate1.replace("{3}", sline)
          stemplate1

      stemplate = makeTemplate(sectionList, true)
      $element.append $compile(stemplate)($scope)
      $scope.$watch "sectionList", (newValue, oldValue) ->
        if newValue isnt oldValue
          stemplate
          sline = makeTemplate(neValue, false)
          $element.find("div").remove()
          $element.append $compile(sline)($scope)
          setTimeout (->
            $(document).foundation "section"
          ), 0

      setTimeout (->
        $(document).foundation "section"
      ), 0
    ]
    link: (scope, iElement, iAttrs, $timeout) ->
      setTimeout (->
        scope.$apply()
        $(document).foundation "section"
      ), 0
      ($scope, iElement, iAttrs, controller) ->

  directiveDefinitionObject


#
#  Radio directive mp-radio
#  model mp-selected
#  
mpradioDirective = ($parse, $compile, $timeout) ->
  directiveDefinitionObject =
    scope:
      mpSelected: "="
      tipTitle: "@"
      tipClass: "@"
      mpLeftLabel: "@"
      mpRightLabel: "@"
      mpValue: "@"
      mpId: '@'
  
    priority: 1000
    template: '<div></div>'
    replace: true
    transclude: false
    restrict: "AE"
    controller: ["$scope", "$element", "$attrs", "$transclude", "$timeout", "radioGlobalService", "mpF4Helper", ($scope, $element, $attrs, $transclude, $timeout, radioGlobalService, mpF4Helper) ->
      if angular.isUndefined($scope.tipTitle)
        tipTitle=""
      else
        tipTitle=$scope.tipTitle
      if angular.isUndefined($scope.tipClass)
        tipClass="has-tip"
      else
        tipClass=$scope.tipClass
      if angular.isUndefined($scope.mpLeftLabel)
        leftLabel=""
      else
        leftLabel=$scope.mpLeftLabel
      if angular.isUndefined($scope.mpRightLabel)
        rightLabel=""
      else
        rightLabel=$scope.mpRightLabel
      if angular.isUndefined($scope.mpValue)
        mpValue=""
      else
        mpValue=$scope.mpValue

      makeTemplate = (id,lLabel,rLabel,tipC,tipT,value,disabled,checked,element,replace)->
        #element[0].removeAttribute("mp-radio")
        radiohtml=""
        radiohtml= radiohtml + '<input name="{0}" type="radio" id="{0}" style="display:none;" value="{1}" {2} {3}/>'  
        radiohtml = radiohtml.replace("{0}",id)
        radiohtml = radiohtml.replace("{0}",id)
        radiohtml = radiohtml.replace("{1}",value)
        if disabled
          radiohtml = radiohtml.replace("{2}","DISABLED")
        else
          radiohtml = radiohtml.replace("{2}","")
        if checked
          radiohtml = radiohtml.replace("{3}","CHECKED")
        else
          radiohtml = radiohtml.replace("{3}","")
        template1=""
        if !replace
          template1 = '<div>'

        template1= template1 + '<label for="{0}" {1} {2} data-tooltip data-options="disable-for-touch:true">' + lLabel + radiohtml + '<span class="custom radio"></span>' + rLabel + '</label>'
        if !replace
          template1 = template1 + '</div>'
        template1 = template1.replace("{0}",id)
        if tipT == ""
          template1 = template1.replace("{1}",'')
          template1 = template1.replace("{2}", '')
        else
          template1 = template1.replace("{1}",'class="' + tipC + '"')
          template1 = template1.replace("{2}", 'title="' + tipT + '"')

        if !replace
          $element.append($compile(template1)($scope))
        else
          $element.find("div").remove()
          $element.append $compile(template1)($scope)
        setTimeout (->
          $(document).foundation "forms"
        ), 0
      radioClick = (ctrl) ->
        $scope.$apply ->
          input=$element.find("input")
          #radios = radioGlobalService.getRadios(ctrl.currentTarget.id)
          $scope.mpSelected = input[0].value
      $scope.$watch "mpSelected", (newValue, oldValue) ->
        if angular.isDefined(newValue)
          setMPValue newValue 
      
      disabled=angular.isDefined($element[0].disabled)
      mpValue=$element[0].getAttribute("mp-value")
      checked=false
      if mpValue == $scope.mpSelected
        checked=true
      if $element[0].id isnt ""
        $attrs.mpId=$element[0].id
        $element[0].id=''
      makeTemplate($attrs.mpId,leftLabel,rightLabel,tipClass,tipTitle,mpValue,disabled,checked,$element,true)
      #radioGlobalService.registerRadio $scope, $element, $attrs, $transclude
      #radios = radioGlobalService.getRadios($attrs.id)
      #idx = radios.length - 1
      #$element[0].setAttribute "idx", idx
      setMPValue = (value) ->
        inputelm=$element.find("input")
        if inputelm and value is inputelm[0].value
          inputelm[0].checked=true
          setTimeout (->
            $(document).foundation "forms"
          ), 0

      setMPValue $scope.mpSelected
      
      $element.bind "change", radioClick
   

    ]
    link: (scope, iElement, iAttrs, $timeout) ->
      ($scope, iElement, iAttrs, controller) ->

  directiveDefinitionObject


#
#  Checkbox directive mp-checkbox
#  mp-checked
#  mp-checked-value
#  mp-unchecked-value
#  
mpcheckboxDirective = ($parse, $compile, $timeout) ->
  directiveDefinitionObject =
    scope:
      mpChecked: "="
      mpCheckedValue: "@"
      mpUncheckedValue: "@"
      tipTitle: "@"
      tipClass: "@"
      mpLeftLabel: "@"
      mpRightLabel: "@"
      mpValue: "@"
      mpId: '@'
  
    template: '<div></div>'
    priority: 1000
    replace: true
    transclude: false
    restrict: "EA"
    controller: ["$scope", "$element", "$attrs", "$transclude", "$timeout", "radioGlobalService", "mpF4Helper", ($scope, $element, $attrs, $transclude, $timeout, radioGlobalService, mpF4Helper) ->
      uniqAId = mpF4Helper.getRandomName("clearing_")
      divUId = mpF4Helper.getRandomName("clearingdiv_")
      checkValue = true
      uncheckValue = false
      checkValue = $scope.mpCheckedValue  if mpF4Helper.type($scope.mpCheckedValue) isnt "undefined"
      uncheckValue = $scope.mpUncheckedValue  if mpF4Helper.type($scope.mpUncheckedValue) isnt "undefined"
      if angular.isUndefined($scope.tipTitle)
        tipTitle=""
      else
        tipTitle=$scope.tipTitle
      if angular.isUndefined($scope.tipClass)
        tipClass="has-tip"
      else
        tipClass=$scope.tipClass
      if angular.isUndefined($scope.mpLeftLabel)
        leftLabel=""
      else
        leftLabel=$scope.mpLeftLabel
      if angular.isUndefined($scope.mpRightLabel)
        rightLabel=""
      else
        rightLabel=$scope.mpRightLabel
      if angular.isUndefined($scope.mpValue)
        mpValue=""
      else
        mpValue=$scope.mpValue

      makeTemplate = (id,lLabel,rLabel,tipC,tipT,value,disabled,checked,element,replace)->
        #element[0].removeAttribute("mp-radio")
        radiohtml=""
        radiohtml= radiohtml + '<input name="{0}" type="checkbox" id="{0}" style="display:none;" value="{1}" {2} {3}/>'  
        radiohtml = radiohtml.replace("{0}",id)
        radiohtml = radiohtml.replace("{0}",id)
        radiohtml = radiohtml.replace("{1}",value)
        if disabled
          radiohtml = radiohtml.replace("{2}","DISABLED")
        else
          radiohtml = radiohtml.replace("{2}","")
        if checked
          radiohtml = radiohtml.replace("{3}","CHECKED")
        else
          radiohtml = radiohtml.replace("{3}","")
        template1=""
        if !replace
          template1 = '<div>'

        template1= template1 + '<label for="{0}" {1} {2} data-tooltip data-options="disable-for-touch:true">' + lLabel + radiohtml + '<span class="custom checkbox"></span>' + rLabel + '</label>'
        if !replace
          template1 = template1 + '</div>'
        template1 = template1.replace("{0}",id)
        if tipT == ""
          template1 = template1.replace("{1}",'')
          template1 = template1.replace("{2}", '')
        else
          template1 = template1.replace("{1}",'class="' + tipC + '"')
          template1 = template1.replace("{2}", 'title="' + tipT + '"')

        if !replace
          $element.append($compile(template1)($scope))
        else
          $element.find("div").remove()
          $element.append $compile(template1)($scope)
        setTimeout (->
          $(document).foundation "forms"
        ), 0

      setValue = (value) ->
        if mpF4Helper.type($scope.mpCheckedValue) isnt "undefined"
          input = $element.find('input')
          if value is checkValue
            input[0].checked=true
          else
            delete input[0].checked  if mpF4Helper.type(input[0].checked) isnt "undefined"
          setTimeout (->
            $(document).foundation "forms"
          ), 0

      #setValue $scope.mpChecked

      checkboxClick = (ctrl) ->
        $scope.$apply ->
          input=$element.find("input")
      
          if angular.isDefined(input[0].checked) and input[0].checked
            $scope.mpChecked = checkValue
          else
            $scope.mpChecked = uncheckValue


      $scope.$watch "mpChecked", (newValue, oldValue) ->
        setValue newValue

      disabled=angular.isDefined($element[0].disabled)
      mpValue=$element[0].getAttribute("mp-value")
      checked=false
      if mpValue == $scope.mpSelected
        checked=true
      if $element[0].id isnt ""
        $attrs.mpId=$element[0].id
        $element[0].id=''
      makeTemplate($attrs.mpId,leftLabel,rightLabel,tipClass,tipTitle,mpValue,disabled,checked,$element,true)
  
      $element.bind "change", checkboxClick
    ]
    link: (scope, iElement, iAttrs, $timeout) ->
      ($scope, iElement, iAttrs, controller) ->

  directiveDefinitionObject

mpcheckboxDirective1 = ($parse, $compile, $timeout) ->
  directiveDefinitionObject =
    scope:
      mpChecked: "="
      mpCheckedValue: "@"
      mpUncheckedValue: "@"

    priority: 1000
    replace: false
    transclude: true
    restrict: "A"
    controller: ["$scope", "$element", "$attrs", "$transclude", "$timeout", "radioGlobalService", "mpF4Helper", ($scope, $element, $attrs, $transclude, $timeout, radioGlobalService, mpF4Helper) ->
      uniqAId = mpF4Helper.getRandomName("clearing_")
      divUId = mpF4Helper.getRandomName("clearingdiv_")
      checkValue = true
      uncheckValue = false
      checkValue = $scope.mpCheckedValue  if mpF4Helper.type($scope.mpCheckedValue) isnt "undefined"
      uncheckValue = $scope.mpUncheckedValue  if mpF4Helper.type($scope.mpUncheckedValue) isnt "undefined"
      setValue = (value) ->
        if mpF4Helper.type($scope.mpCheckedValue) isnt "undefined"
          if value is checkValue
            $element[0].checked=true
          else
            delete $element[0].checked  if mpF4Helper.type($element[0].checked) isnt "undefined"
          setTimeout (->
            $(document).foundation "forms"
          ), 0

      setValue $scope.mpChecked
      checkboxClick = (ctrl) ->
        $scope.$apply ->
          if ctrl.currentTarget.checked
            $scope.mpChecked = checkValue
          else
            $scope.mpChecked = uncheckValue


      $scope.$watch "mpChecked", (newValue, oldValue) ->
        setValue newValue

      $element.bind "change", checkboxClick
    ]
    link: (scope, iElement, iAttrs, $timeout) ->
      ($scope, iElement, iAttrs, controller) ->

  directiveDefinitionObject

#
#  Checkbox directive mp-checkbox
#  mp-checked
#  mp-checked-value
#  mp-unchecked-value
#  
mpswitchDirective = ($parse, $compile, $timeout) ->
 
  directiveDefinitionObject =
    scope:
      mpClass: "@"
      mpChecked: "="
      mpCheckedValue: "@"
      mpUncheckedValue: "@"
      tipTitle: "@"
      tipClass: "@"

    priority: 1000
    replace: true
    template: '<div></div>'
    transclude: false
    restrict: "E"
    controller: ["$scope", "$element", "$attrs", "$transclude", "$timeout", "radioGlobalService", "mpF4Helper", ($scope, $element, $attrs, $transclude, $timeout, radioGlobalService, mpF4Helper) ->
      uniqAId = mpF4Helper.getRandomName("x")
      uniqName = "switch-" + uniqAId
      uniqId1 = uniqAId
      uniqId2 = uniqAId + "1"
      if angular.isUndefined($scope.tipTitle)
        tipTitle=""
      else
        tipTitle=$scope.tipTitle
      if angular.isUndefined($scope.tipClass)
        tipClass="has-tip"
      else
        tipClass=$scope.tipClass
      if angular.isUndefined($scope.mpClass)
        mpClass = "switch"
      else
        mpClass = $scope.mpClass
      checkValue = "ON"
      uncheckValue = "OFF"
      checkValue = $scope.mpCheckedValue  if angular.isDefined($scope.mpCheckedValue)
      uncheckValue = $scope.mpUncheckedValue  if angular.isDefined($scope.mpUncheckedValue)
      makeTemplate = (unCheckV, checkV, defaultV, tipC,tipT,replace) ->
        line1 = ""
        
        if tipT == ""
          line1 = "<div>"
        else
          line1 = '<div class="' + tipC + '" title="' + tipT + '">'

        line1 = line1 + "<div class=\"{0}\">"
        line1 = line1 + "<input id=\"{1}\" name=\"{2}\" type=\"{3}\" {4} >"
        line1 = line1 + "<label for=\"{5}\" onclick=\"\" ng-click=\"labelClick(this,false)\">{6}</label>"
        line1 = line1 + "<input id=\"{7}\" name=\"{8}\" type=\"{9}\" {10} >"
        line1 = line1 + "<label for=\"{11}\" onclick=\"\" ng-click=\"labelClick(this,true)\">{12}</label>"
        line1 = line1 + "</div>"
        line1 = line1 + "</div>"
        line1 = line1.replace("{0}", mpClass)
        line1 = line1.replace("{1}", uniqId1)
        line1 = line1.replace("{2}", uniqName)
        line1 = line1.replace("{3}", "radio")
        if defaultV is unCheckV
          checked = "checked"
        else
          checked = ""
        line1 = line1.replace("{4}", checked)
        if checked is ""
          checked = "checked"
        else
          checked = ""
        line1 = line1.replace("{5}", uniqId1)
        line1 = line1.replace("{6}", unCheckV)
        line1 = line1.replace("{7}", uniqId2)
        line1 = line1.replace("{8}", uniqName)
        line1 = line1.replace("{9}", "radio")
        line1 = line1.replace("{10}", checked)
        line1 = line1.replace("{11}", uniqId2)
        line1 = line1.replace("{12}", checkV)
        unless replace
          $element.append $compile(line1)($scope)
        else
          $element.find("div").remove()
          $element.append $compile(line1)($scope)
        setTimeout (->
          $(document).foundation "forms"
        ), 0

      makeTemplate uncheckValue, checkValue, $scope.mpChecked,tipClass,tipTitle, false
      $scope.$watch "mpChecked", (newValue, oldValue) ->
        makeTemplate uncheckValue, checkValue, newValue, tipClass, tipTitle, true

      checkboxClick = (ctrl) ->
        $scope.$apply ->
          input = $element.find("input")
          soff = input[0].checked
          son = input[1].checked
          $scope.mpChecked = uncheckValue  if mpF4Helper.type(soff) isnt "undefined" and soff is true
          $scope.mpChecked = checkValue  if mpF4Helper.type(son) isnt "undefined" and son is true
        
    

      $element.bind "change", checkboxClick
      labelClick = (ctrl, value) ->
        if value
          $scope.mpChecked = checkValue
        else
          $scope.mpChecked = uncheckValue
    ]
    link: (scope, iElement, iAttrs, $timeout) ->
      setTimeout (->
        $(document).foundation "forms"
      ), 0
      ($scope, iElement, iAttrs, controller) ->

  directiveDefinitionObject

myF4_DirectiveApp.directive "mpDropdown", mpdropdownDirective
myF4_DirectiveApp.directive "mpDropdownContent", mpdropdownContentDirective
myF4_DirectiveApp.directive "mpClearing", mpclearingDirective
myF4_DirectiveApp.directive "mpAlertBox", mpalertBoxesDirective
myF4_DirectiveApp.directive "mpSection", mpsectionDirective
myF4_DirectiveApp.directive "mpSectionContainer", mpsectionContainerDirective
myF4_DirectiveApp.directive "mpRadio", mpradioDirective
myF4_DirectiveApp.directive "mpCheckbox", mpcheckboxDirective
myF4_DirectiveApp.directive "mpCheckbox1", mpcheckboxDirective1
myF4_DirectiveApp.directive "mpSwitch", mpswitchDirective
