'use strict'

mpDirectiveApp=angular.module('mpDirectiveApp',[])

mpDirectiveApp.factory 'mpF4Helper', [() ->
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
 
  clone: (obj) ->
    if not obj? or typeof obj isnt 'object'
      return obj
  
    if obj instanceof Date
      return new Date(obj.getTime()) 
  
    if obj instanceof RegExp
      flags = ''
      flags += 'g' if obj.global?
      flags += 'i' if obj.ignoreCase?
      flags += 'm' if obj.multiline?
      flags += 'y' if obj.sticky?
      return new RegExp(obj.source, flags) 
  
    newInstance = new obj.constructor()
  
    for key of obj
      newInstance[key] = @clone obj[key]
  
    return newInstance
]


mpDirectiveApp.factory "fileReader", ["$q","$log",($q,$log)->
  onLoad = (reader,deferred,scope)->
    ()->
      scope.$apply(()->
        deferred.resolve(reader.result))
    
  onError = (reader, deferred, scope)->
    () ->
      scope.$apply ()->
        deferred.reject(reader.result)
    
  onProgress = (reader,scope)->
    (event)->
      scope.$broadcast("fileProgress",{total: event.total,loaded:event.loaded})
    
  getReader = (deferred, scope)->
    reader = new FileReader()
    reader.onload = onLoad(reader,deferred,scope)
    reader.onerror = onError(reader,deferred,scope)
    reader.onprogress=onProgress(reader,scope)
    return reader
  readAsDataURL = (file,scope)->
    deferred = $q.defer()
    reader = getReader deferred,scope
    reader.readAsDataURL file
    return deferred.promise
  readAsBinaryString = (file,scope)->
    deferred = $q.defer()
    reader = getReader deferred,scope
    reader.readAsBinaryString file
    return deferred.promise
  readAsArrayBuffer = (file,scope) ->
    deferred = $q.defer()
    reader = getReader deferred,scope
    reader.readAsArrayBuffer file
    return deferred.promise
  return { readAsDataUrl: readAsDataURL,readAsBinaryString: readAsBinaryString,readAsArrayBuffer: readAsArrayBuffer}    
]



mpPictureFrameDirective = ($parse,$timeout,mpF4Helper) ->
  
  readFileFn = (file,sc,width,height,scale,f4helper,callbackfunction)->
    sc.fileReader.readAsDataUrl(file,sc).then (result)->
        #$scope.User.user_data.picture="data:image/jpg;base64,"+btoa(result)
         
        
  
      getThumbnail = (original, width,height, orig_width,orig_height)->
        canvas = document.createElement("canvas")
        newcanvas_id=f4helper.getRandomName 'mp_'
        #canvas.setAttribute 'id',newcanvas_id
        #uncomment the following line disable use of caman for the time being
        canvas.width = width
        canvas.height = height
      
        orig_crop_y=(orig_height/orig_width)*width
        canvas.height=orig_crop_y
        canvas.getContext("2d").clearRect(0,0,width,height) 
        canvas.getContext("2d").drawImage original, 0, 0, canvas.width,canvas.height
        return canvas
  
      genThumbnail = (data, width,height,scale,callbackfn)->
        self=this
        image = new Image()
        width=width
        height=height
        newimg=null  
  
        image.onload= ()->
          if scale
            width=image.width * scale
            height=image.height * scale
          orig_width=image.width
          orig_height=image.height
          canvas = getThumbnail image, width, height, orig_width,orig_height
          newimg = canvas.toDataURL()  
          callbackfn?(canvas,newimg) 
    
        image.src=data   
  
      newimg=genThumbnail result,width,height,scale,callbackfunction
      return

  canvasImgName=mpF4Helper.getRandomName('mp_')
  
  directiveDefinitionObject = {
    priority: 0
    template: '<div >'+
                '<div>'+
                '<img ng-src="" />'+
                '<canvas style="display:none; visibility:hidden;"></canvas>'+
                '</div>'+
                '<div style="position:relative;">'+
                '<input type="file" style="position: relative;text-align: right;opacity: 0;filter: alpha(opacity=0);z-index: 2;"/>'+
                '<a href="#" style="border-style: solid;border-width: 1px;cursor: pointer;font-family: inherit;font-weight: bold;line-height: 1;margin: 0 0 1.25em;position: relative;text-decoration: none;text-align: center;display: inline-block;padding-top: 0.75em;padding-right: 1.5em;padding-bottom: 0.8125em;padding-left: 1.5em;font-size: 1em;background-color: #2ba6cb;border-color: #2284a1;color: white;position: absolute;top: 0px;left: 0px;z-index: 1;" >'+
                'Select</a>'+
                '</div>'+
              '</div>'; 
    
    replace: true
    transclude: false
    restrict: 'AE'
    scope: {
      frameWidth:'='
      frameHeight:'='
      frameFile:'='
      frameClass:'='
      framePictureClass:'='
      frameInputFileClass:'='
      frameButtonClass:'='
      frameButtonText:'@'
      frameStyle: '='
      framePictureStyle: '='
      frameInputFileStyle: '='
      frameModel: '='
      }
    controller: [
      "$scope"
      "$element"
      "$attrs"
      "$transclude"
      "fileReader"
      "mpF4Helper"
      ($scope,$element,$attrs,$transclude,fileReader,mpF4Helper)->
        if !$attrs.frameFile
          $attrs.$set('frameFile','')
        #if !$attrs.onChange
        #  $attrs.$set('onChange',readFileFn)
        if !$scope.readFile
          $scope.readFile=readFileFn
        if !$scope.fileReader
          $scope.fileReader=fileReader
       
        canvasElm=$element.find("canvas")
        newcanvas_id=mpF4Helper.getRandomName("mp_") 
        canvasElm[0].setAttribute("id",newcanvas_id) if canvasElm    
        imgElm=$element.find('img')
        
        #Set Img ID
        #if imgElm and $attrs.frameModel
        #  imgElm[0].setAttribute('ng-src',$attrs.frameModel)
          #imgElm[0].setAttribute('ng-model',$attrs.ngModel)
          
        elmInput=$element.find('input')
        elmImg = $element.find('img')
        $timeout ()->    
          if $scope.frameModel?
            elmImg[0].src=$scope.frameModel if elmImg
              
        updateModel = ()->      
          $scope.$apply ()->
            #fileGetter.assign(scope,iElement[0].childNodes[0].files[0])
            $scope.readFile?(elmInput[0].files[0],$scope,$scope.frameWidth,$scope.frameHeight,null,mpF4Helper,(canvas,newimg)->
              elmImg[0].src=newimg if elmImg
              $scope.frameModel=newimg
              #call $apply to make the changes made to frameModel effective
              $scope.$apply()
              return
            )
        elmInput.bind('change',updateModel)
        
        return
    ]
    #compile:
    link: (scope, iElement, iAttrs,$timeout)=>
      elmInput=iElement.find('input')
      elmImg=iElement.find('img')
      elmA=iElement.find('a')
     #divElm=iElement.find('div')
     #set class
      #Outer Frame
         
      iElement[0].className=iElement[0].className + ' ' + iAttrs.frameClass if iAttrs.frameClass
      #PictureFrame
      iElement[0].childNodes[0].className= iElement[0].childNodes[0].className + ' ' + iAttrs.framePictureClass if iAttrs.framePictureClass
      #inputFileClass
      iElement[0].childNodes[1].className= iElement[0].childNodes[1].className + ' ' + iAttrs.frameInputFileClass if iAttrs.frameInputFileClass
      
      #set style
      #Outer Frame
      iElement[0].style=iAttrs.frameStyle if iAttrs.frameStyle
      #PictureFrame
      iElement[0].childNodes[0].style= iAttrs.framePictureStyle if iAttrs.framePictureStyle
      #inputFileClass
      iElement[0].childNodes[1].style= iAttrs.frameInputFileStyle if iAttrs.frameInputFileStyle
      
      elmA[0].className=iAttrs.frameButtonClass if iAttrs.frameButtonClass and elmA
        
      onChange = iAttrs.onChange
      width=iAttrs.frameWidth
      height=iAttrs.frameHeight
   
      aElm=iElement.find('a')
   
      scope.$watch 'frameButtonText', (newValue,oldValue)->
        aElm[0].innerHTML = newValue if aElm and newValue
      scope.$watch 'frameModel', (newValue,oldValue)->
        elmImg[0].src = newValue if elmImg and newValue
      
       
      
      return
          
    
  }
  return directiveDefinitionObject  
  
mpDirectiveApp.directive 'mpPictureFrame', mpPictureFrameDirective

