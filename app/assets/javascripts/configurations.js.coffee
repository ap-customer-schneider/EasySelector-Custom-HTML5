#= require html5shiv
#= require respond
#= require bootstrap.min
#= require shadowbox

$baseHelpURL = 'http://quotefast.schneider-electric.com/solutionone/SOWPHelp/prodhelp.php?ndx=37991&doc=advisor'
$helpURL = null
$productIdentifier = null
$areq = null
$prodSubsetURL = null
$dependantCount = 0
$is_ie_lt9 = false
$AP_outside = {}
container_name = '#config-container'
container_class = '.big-box'
intervals = 0
$maxCapacity = null
currCapacity = null
$differenceVal = 0
$capacityMax = null
window.runningCap = 0
window.baseHelp = 'http://quotefast.schneider-electric.com/solutionone/SOWPHelp/prodhelp.php?ndx=37991&doc=advisor'


if navigator.userAgent.match(/IEMobile\/10\.0/)
  msViewportStyle = document.createElement("style")
  msViewportStyle.appendChild document.createTextNode("@-ms-viewport{width:auto!important}")
  document.getElementsByTagName("head")[0].appendChild msViewportStyle

AP = window.AP

# Backport Array.prototype.filter
unless Array::filter
  Array::filter = (fn, context) ->
    i = undefined
    value = undefined
    result = []
    length = undefined
    length = @length
    i = 0
    while i < length
      if @hasOwnProperty(i)
        value = this[i]
        result.push value  if fn.call(context, value, i, this)
      i++
    result

# Backport Array.prototype.forEach
unless Array::forEach
  Array::forEach = forEach = (callback, thisArg) ->
    "use strict"
    T = undefined
    k = undefined
    kValue = undefined
    O = Object(this)
    len = O.length >>> 0 # Hack to convert O.length to a UInt32
    T = thisArg  if arguments.length >= 2
    k = 0
    while k < len
      if k of O
        kValue = O[k]
        callback.call T, kValue, k, O
      k++

# Backport Array.prototype.map
unless Array::map
  Array::map = (callback, thisArg) ->
    T = undefined
    A = undefined
    k = undefined
    O = Object(this)
    len = O.length >>> 0
    T = thisArg  if thisArg
    A = new Array(len)
    k = 0
    while k < len
      kValue = undefined
      mappedValue = undefined
      if k of O
        kValue = O[k]
        mappedValue = callback.call(T, kValue, k, O)
        A[k] = mappedValue
      k++
    A

# Backport Array.prototype.reduce
if "function" isnt typeof Array::reduce
  Array::reduce = (callback, opt_initialValue) ->
    "use strict"
    index = undefined
    value = undefined
    length = @length >>> 0
    isValueSet = false
    if 1 < arguments.length
      value = opt_initialValue
      isValueSet = true
    index = 0
    while length > index
      if @hasOwnProperty(index)
        if isValueSet
          value = callback(value, this[index], index, this)
        else
          value = this[index]
          isValueSet = true
      ++index
    value

# Backport Object.keys
unless Object.keys
  Object.keys = (->
    "use strict"
    hasOwnProperty = Object::hasOwnProperty
    hasDontEnumBug = not (toString: null).propertyIsEnumerable("toString")
    dontEnums = ["toString", "toLocaleString", "valueOf", "hasOwnProperty", "isPrototypeOf", "propertyIsEnumerable",
                 "constructor"]
    dontEnumsLength = dontEnums.length
    (obj) ->
      result = []
      prop = undefined
      i = undefined
      for prop of obj
        result.push prop  if hasOwnProperty.call(obj, prop)
      if hasDontEnumBug
        i = 0
        while i < dontEnumsLength
          result.push dontEnums[i]  if hasOwnProperty.call(obj, dontEnums[i])
          i++
      result)()


adv_init = ->
  # Init final parts list
  AP.finalParts = []
  AP.optionDependants = []

  # Replace any existing viewport tags with our custom viewport
  _viewport = $('head > meta[name=viewport]:last')
  apViewport = $('<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/>')
  if _viewport.length > 0
    _viewport.replaceWith apViewport
  else
    $('head').append(apViewport)

  # Set the modal
  $('#ap-container').modal()
  # On modal disclosure, remove custom viewport and replace existing one if available
  $('#ap-container').on('hidden.bs.modal', (e)->
    $(apViewport, 'head').remove()
    if _viewport.length > 0
      $('head').append(_viewport)
  )

  # Hide controls and n/a values
  $(container_name + " input[value=\"n_a\"] + label").hide()
  $(container_name + " input[value=\"n_a\"]").hide()
  unless $(container_name + " input:radio").val() is "n_a"
    $(container_name + " .ap-fieldset-fields input:radio:last").parent("label").show()
  else
    $(container_name + " .ap-fieldset-fields input:radio:last").parent("label").hide()

  $productIdentifier = $("#ap-headline").data('id')
  document.getElementById('ap-help-button').setAttribute('href',$baseHelpURL.concat('&prod=').concat($productIdentifier))
  $helpURL = $baseHelpURL.concat('&prod=').concat($productIdentifier)

  # Show or hide the option values based on a subset being selected
  $('#ap-psubset-select').on (
    change: ->
      $dependantCount = 0
      # Clear previous full image display links - if any
      $prodSubsetURL = $helpURL.concat('&subset=', $('option:selected', this).data('sku'))
      Shadowbox.clearCache()
      # Get target for image update
      image_link = $(container_name + " .modal-header .ap-image > a.ap-sb-link")
      thumb = $('option:selected', this).data('thumb') || $("option[value='ap-unselected']", this).data('thumb')
      image = $('option:selected', this).data('image') || $("option[value='ap-unselected']", this).data('image')
      title = $('option:selected', this).data('title').replace(/'/g, '') || $("option[value='ap-unselected']", this).data('title').replace(/'/g, '')
      image_link.prop('href', image) if image
      image_link.prop('title', title) if title
      $('img', image_link).prop('src', thumb) if thumb

      if $(this).val() is "ap-unselected"
        $(".ap-content", "#ap-left-side").hide()
        $(".ap-hlp-wrapper").show()
      else
        $(".ap-content", "#ap-left-side").removeClass('hide').show()
        $(".ap-hlp-wrapper").hide()

      Shadowbox.setup 'a.ap-sb-link', {player: 'img'}
      resetForm()
  )

  # Click Handler for close button in top right
  $('#ap-close-button').on (
    click: ->
      $('#overlaycontainer').hide()
      $('#overlayOpacity').hide()
      $('#overlayOpacity').css('filter', 'alpha(opacity=20)')
      $('#overlayOpacity').fadeIn('fast')
      $('#overlaycontainer').fadeIn('fast')
  )

  $('#ap-close-button-nest').on (
    click: ->
      $('#overlaycontainerNest2').hide()
      $('#overlayOpacityNest2').hide()
      $('#overlayOpacityNest2').css('filter', 'alpha(opacity=20)')
      $('#overlayOpacityNest2').fadeIn('fast')
      $('#overlaycontainerNest2').fadeIn('fast')
      $('#popup_box-nest').show()
  )


  $('.deleteconfirmbuttonyes').on (
    click: ->
      window.top.postMessage
        fn: "CloseEasySelector"
        "*"
      $("#ap-container").modal('hide')

  )

  $('.deleteconfirmbuttonno').on (
    click: ->
      $('#overlaycontainer').fadeOut('fast')
      $('#overlayOpacity').fadeOut('fast')
  )

  document.onkeydown = (evt) ->
    evt = evt or window.event
    window.top.postMessage
      fn: "CloseEasySelector"
      "*"  if evt.keyCode is 27
    return

  # Click handlers set on option values to select hidden radio buttons
  $(container_name + ' input:radio + label').on(
    click: (e)->
      id = $(e.currentTarget).attr('for')
      # click change event for ie8 radio buttons
      if $("html").hasClass("ie8")
        $("##{id}").click().change()
      else
        $("##{id}").click()


  )

  # Click Handler for edit buttons
  $(container_name + ' .option-edit').on(
    click: (e)->
      id = $(e.currentTarget).attr('for')
      option = $("[data-option='#{id}']")
      $(this).closest('.ap-fieldset').removeClass('edited')
      window.runningCap = 0
      modifyDependantCount(-1)
      enableSingleOption option
  )

  # Hide the accessory + button on click and display the input for quantity
  $(container_name).on 'click', '.ap-add-quantity', (e) ->
      $(e.currentTarget).hide()
      .siblings('.ap-quantity').show().focus()


  # Clicking subset choice images should only open shadowbox
  $(container_name + ' a.ap-sb-link').on(
    click:(e)->
      e.stopPropagation();
  )
  # Click Handler for subset choices
  $(container_name + ' .ap-subset-item').on(
    click: (e)->
      subset = $('#ap-psubset-select')
      $("option[name=\"" + subset.prop('name') + "\" ][value=\"" +  $(this).data('value') + "\"]").prop "selected", true
      $('#ap-psubset-container').show()
      $('#ap-psubset-select').change()
  )

  $(container_name).on 'focus', '.ap-quantity', (e) ->
    data = undefined
    target = undefined
    target = $(e.currentTarget)
    data = target.data()
    $differenceVal = 0

    target.blur()  if data.min is data.max and data.min isnt -1 and target.closest(".ap-rtype-item").hasClass("ap-part-item")
    target.addClass "focused"
    target.removeClass "focusOn"  if target.hasClass("focusOn")
  $(container_name).on 'blur', '.ap-quantity', (e) ->
    capacity = undefined
    data = undefined
    maximum = undefined
    minimum = undefined
    target = undefined
    val = undefined
    target = $(e.currentTarget)
    data = target.data()
    val = Math.abs(parseInt(target.val()) or 0)

    if target.parent().hasClass("ap-part-item") && Math.abs(parseInt(target.attr("max"))) > 1
      currCapacity = (intervals * (target.val() - 1)) + $maxCapacity
      $(container_name).find("#ap-accessories").find("a").each ->
        str = $(this).attr('href')
        str = str.replace(/maxcap=.\&/,"maxcap="+currCapacity+"\&") if str
        $(this).attr('href', str) if str
    if val == 0  and target.closest(".ap-rtype-item").data().type is "accessory"
      target.val(Math.abs(data.min)).hide().siblings(".ap-add-quantity").show()
      target.parent().find('.ap-quant-remove').hide()
      #jQuery(e.currentTarget).next().fadeOut "fast"
      target.removeClass "focused"
    else
      if target.closest(".ap-rtype-item").attr("boxvalue")
        target.val val
        #$maxCapacity = $maxCapacity * val
        minimum = Math.abs(parseInt(target.closest(".ap-rtype-item").attr("min")))
        maximum = Math.abs(parseInt(target.closest(".ap-rtype-item").attr("max")))
        unitCapacity = Math.abs(parseInt(target.closest(".ap-rtype-item").attr("unitcapacity")))
        target.data "min", minimum
        target.data "max", maximum
        target.data "unitcapacity", unitCapacity

      data = target.data()
      val = Math.max(val, data.min)
      val = Math.min(val, data.max)  if data.max > -1
      target.val Math.abs(val)
      target.parent().find('.ap-quant-remove').fadeIn "fast"
      #jQuery(e.currentTarget).next().fadeIn "fast"
    capacity = 0
    keepFocus = false
    if !target.parent().hasClass("ap-part-item")
      $(container_name).find("#ap-accessories").find("li").not('.naccessory').each (i, li) ->

        $differenceVal = undefined
        capacitySingle = undefined
        unitCap = 1
        #if $(this).find(".ap-quantity").data("unitcapacity") isnt "N/A"
        capacitySingle = Math.abs(parseInt($(this).find(".ap-quantity").val()))

        if $(this).find(".ap-quantity").data("unitcapacity") > 1 and (currCapacity > 0 || currCapacity == 0 )
          unitCap = Math.abs(parseInt($(this).find(".ap-quantity").data("unitcapacity")))
          capacitySingle = capacitySingle * unitCap

        if capacitySingle > 0 and $(this).find(".focused").length and $(this).find(".ap-quantity").data("unitcapacity") > 0 and $(this).find('.ap-quantity').is(":visible")
          if not $(this).find(".ap-quant-remove").length
            $(this).append('<i class="fa fa-times ap-quant-remove" style="display:inline;margin-top:-30px;"/>')


          capacity = capacitySingle + capacity
          window.runningCap = capacity

      if currCapacity > 0 or currCapacity == 0
        if currCapacity < capacity and not $(container_name).find("#ap-accessories").find("ul").find(".focusOn").length
          cap = Math.abs(parseInt(target.parent().find(".ap-quantity").data("unitcapacity")))
          $differenceVal = parseInt((capacity - currCapacity) / cap)
          differenceValue target, $differenceVal, cap, capacity, currCapacity
          keepFocus = true
          target.find(".ap-quantity").addClass "focusOn"
          $("#overlaycontainerCapacity").hide()
          $("#overlayOpacityCapacity").hide()
          $("#overlayOpacityCapacity").css "filter", "alpha(opacity=20)"
          $("#overlayOpacityCapacity").fadeIn "fast"
          $("#overlaycontainerCapacity").fadeIn "fast"
          $("#overlaycontainerCapacity").css "z-index", "99999"
          false


  differenceValue = (e, differenceVal, unitCap, capacity, currCapacity) ->
    if (capacity - currCapacity) % unitCap is 0
      e.val (e.val()) - differenceVal

    else
      e.val (e.val()) - differenceVal - 1

    if e.val() <= "0"
      e.hide()
      e.siblings(".ap-add-quantity").show()
      e.parent().find(".ap-quant-remove").remove()
      e.val(e.attr("data-min"))


    return


  # click confirm button on over max capacity popup
  $('.deleteconfirmbuttoncapacity').on (
    click: ->
      # focus back on offending capacity count input box
      $('.focusOn').focus()
      $('#overlaycontainerCapacity').fadeOut('fast')
      $('#overlayOpacityCapacity').fadeOut('fast')
  )



  $(container_name).on 'click', '.ap-quant-remove', (e) ->
    if $(this).parent().find(".ap-quantity").data("unitcapacity") > 0
      window.runningCap = window.runningCap - ($(this).parent().find(".ap-quantity").data("unitcapacity") * $(e.currentTarget).siblings('.ap-quantity').val())
    #$(e.currentTarget).siblings('.ap-quantity').hide()
    #$(this).siblings('.ap-add-quantity').show()
    #jQuery(e.currentTarget).fadeOut('fast')

    #$(e.currentTarget).siblings('.ap-quantity').val(1)
    if $(this).parent().hasClass("nested")
      $(this).parent().remove()
    else
      $(e.currentTarget).siblings('.ap-quantity').hide()
      $(this).siblings('.ap-add-quantity').show()
      jQuery(e.currentTarget).fadeOut('fast')
      $(e.currentTarget).siblings('.ap-quantity').val(1)

  $(container_name).on 'mouseleave', '.ap-quant-remove', (e) ->

  $(container_name).on 'mouseenter', '.ap-quant-remove', (e) ->
    $(e.currentTarget).next().show()

  # Write out final parts list and do analytics on submission
  $(container_name + " #ap-accept-button").click ->
    submitFinalResult()


  $('.deleteconfirmbuttonyesNest').on (
    click: ->
      $('#overlaycontainerNest2').fadeOut('fast')
      $('#overlayOpacityNest2').fadeOut('fast')
      $('#overlaycontainerNest').fadeOut('fast')
      $('#overlayOpacityNest').fadeOut('fast')


      #container_name = '#ap-container'
  )

  $('.deleteconfirmbuttonnoNest').on (
    click: ->
      $('#popup_box-nest').modal('hide')
      $('#overlaycontainerNest2').fadeOut('fast')
      $('#overlayOpacityNest2').fadeOut('fast')
  )

  $('#child-close-button').click ->
    $('.child-selector-container').collapse('hide')

  # Find all available solutions when any option value changes
  $(container_name).find("input:radio,select").on (
    change: ->

      parentTarget = $(this).closest('.ap-fieldset')
      if $(this).val() != 'ap-unselected'
        $(this).closest('.ap-fieldset').addClass('edited')
        if $(this).attr('id') != 'ap-psubset-select'

          # Preferred Image
          togglePreferredImage($(this))

          # Dependant Count
          if $is_ie_lt9 = true
            if $(this).is('select')
              modifyDependantCount(1)
            else
              modifyDependantCount(.5)
          else
            modifyDependantCount(1)
      else
        $(this).closest('.ap-fieldset').removeClass('edited').removeClass('preferred')
        if $(this).attr('id') != 'ap-psubset-select'
          modifyDependantCount(-1)
      findSolution(parentTarget)
      $(this).trigger('blur')
  )

  # Reset the form when the reset button is clicked
  $("#ap-reset-button").click ->
    resetForm()
    findSolution()

hideOption=(option) ->
  if ($(option).length > 0)
    $(option).each ->
      if ($(this).is('option') && $(this).val() != 'ap-unselected' && (!$(this).closest('select').hasClass('hidden-select')) && (!$(this).closest('select').is('#ap-psubset-select')))
        parentName = $(this).closest('select').prop('name') + '-hidden'
        $(this).prop('disabled', true).prop 'selected', false
        $(this).detach()
        $('#config-container select[name=\"' + parentName + '\"]').first().append($(this))

showOption=(option) ->
  if ($(option).length > 0)
    $(option).each ->
      if ($(this).is('option') && $(this).val() != 'ap-unselected' && $(this).closest('select').hasClass('hidden-select') && (!$(this).closest('select').is('#ap-psubset-select')))
        parentName = $(this).closest('select').prop('name').replace('-hidden','');
        $(this).prop 'disabled', false
        $(this).detach()
        # Appending a new option to a select will choose that option.
        # We want to keep the current selected choice, so we record it and reapply after append().
        parent = $('#config-container select[name=\"' + parentName + '\"]').first()
        oldVal = parent.val()
        parent.append($(this))
        parent.sort_select_box()
        parent.val(oldVal)

#sort select box by id function
$.fn.sort_select_box = ->
  # Get options from select box
  my_options = $(this).find("option")
  # sort alphabetically by id
  if my_options.length > 2
    my_options.sort (a, b) ->
      if a.id > b.id
        1
      else if a.id < b.id
        -1
      else
        0
  #replace with sorted my_options;
  $(this).empty().append my_options
  return

# Reenable all option values and remove and find all available solutions
resetForm = ->
  AP.finalParts = []
  AP.finalSolution = {}
  $(container_name + ' .ap-fieldset').removeClass('edited').removeClass('preferred')
  enableAllOptions()
  $dependantCount = 0
  window.runningCap = 0
  modifyDependantCount(0)

# Reset the UI clear parts lists and display messages
clearUI = ->
  $('#config-container .ap-section-list ul li:not(.template)').remove()
  $(container_name + " .ap-section-list .message").show()
  $(container_name + " .ap-section-list .no-results").hide()
  $(container_name + " .test-button").remove()
  # Disable Add Parts Button
  $('#ap-container #ap-accept-button').prop('disabled',true)
  $('.capacity-message').hide()
  $('.flag-container').remove()



# Apply Preferred Image to Selects
togglePreferredImage = (elem) ->
  if $(elem).is('select') || $(elem).is('option')
    if $(elem).first().data('is_preferred') || $(elem).find(':selected').first().data('is_preferred')
      $(elem).closest('.ap-fieldset').addClass('preferred')
    else
      $(elem).closest('.ap-fieldset').removeClass('preferred')

# Disable all option values
disableAllOptions = ->
  $(container_name).find('input:radio').prop("disabled", true).prop "checked", false
  hideOption($(container_name).find('option'))

# Enable all option values
enableAllOptions = ->
  AP.optionDependants = []
  $(container_name).find('input:radio').prop("disabled", false).prop "checked", false
  showOption($(container_name).find('option'))
  $(container_name + " select:not(#ap-psubset-select)").each (i, e) ->
    $(e).val "ap-unselected"

enableSingleOption = (option) ->
  parentTarget = option.closest(container_name + ' .ap-fieldset')
  dependants = findDependants(parentTarget.data('name')) || []
  if dependants.length > 0
    dependants.forEach (e) ->
      elem = $(container_name + " input:radio[name='#{e.name}'], "+ container_name + " select[name='#{e.name}']")
      elem.prop("disabled", false).prop "checked", false
      if elem.is("select")
        showOption($(container_name + ' select[name=\"' + elem.prop('name') + '-hidden\"]').find('option'))
        elem.val("ap-unselected")
        togglePreferredImage(elem)
    AP.optionDependants = filterDependants(parentTarget.data('name'))
  findSolution()

findAvailableOptionsForSolutions = (solutions) ->
  options = []
  i = 0
  while i < solutions.length
    sol = solutions[i]
    sanitizedKeys = sanitizeKeys(sol)
    delete sanitizedKeys[$(container_name + ' #ap-psubset-select').prop('name')]
    # If option exists in current configuration, enable it
    sanitizedKeys.forEach (e) ->
      if $(container_name + " input:radio[name=\"" + e + "\"][value=\"" + sol[e] + "\"]").length
        options.push $(container_name + " input:radio[name=\"" + e + "\"][value=\"" + sol[e] + "\"]")
      if $(container_name + " option[name=\"" + e + "\"][value=\"" + sol[e] + "\"]").length
        options.push $(container_name + " option[name=\"" + e + "\"][value=\"" + sol[e] + "\"]")

    i++
  options

# Iterate through provided solution configurations and filter remaning available options
limitAvailableOptions = (solutions, selected_fieldset) ->
  disableAllOptions()
  i = 0
  while i < solutions.length
    sol = solutions[i]
    sanitizedKeys = sanitizeKeys(sol)
    delete sanitizedKeys[$(container_name + ' #ap-psubset-select').prop('name')]
    # If option exists in current configuration, enable it
    sanitizedKeys.forEach (e) ->
      $(container_name + " input:radio[name=\"" + e + "\"][value=\"" + sol[e] + "\"]").prop "disabled", false
      showOption($(container_name + " option[name=\"" + e + "\"][value=\"" + sol[e] + "\"]"))
    i++
  selectLastOption(selected_fieldset)

# Determine is option is a valid selection
isValidOption = (option) ->
  if option.is("radio") && !option.prop('disabled')
    true
  else if option.is("option") && (!option.prop('disabled')) && (!option.parent().hasClass('hidden-select'))
    true
  else
    false

# Get all fields that depend on another field based on name
matchDependants = (dependantName) ->
  $.grep AP.optionDependants, (item) ->
    item.name is dependantName

# Get all fields that depend on another field based on owner name
findDependants = (dependantParentName) ->
  $.grep AP.optionDependants, (item) ->
    item.dependsOn is dependantParentName

# Get all fields that do not depend on a certain field
filterDependants = (dependantParentName) ->
  $.grep AP.optionDependants, (item) ->
    item.dependsOn isnt dependantParentName

# Select last option if criteria met
selectLastOption = (selected_fieldset) ->
  $(container_name + " fieldset.ap-fieldset").each (i, e) ->
    parentFieldset = $(e)
    elementName = parentFieldset.data("name")
    availableSelection = []
    $(container_name + " [name=\"" + elementName + "\"]").each ->
      ref = $(this)
      if ref.is(":radio") and not (ref.is(":disabled"))
        availableSelection.push ref.val()
      else availableSelection.push ref.val()  if ref.is("option") and (not ref.is(":disabled")) and (ref.val() isnt "ap-unselected")

    if availableSelection.length is 1

      # Add Dependants to fieldset
      if selected_fieldset
        obj = {
          name: elementName,
          value: availableSelection[0]
          dependsOn: selected_fieldset.data('name')
        }
        AP.optionDependants.push(obj) if matchDependants(elementName).length is 0

      # Select the last remaining option
      lastOption = $("[name=\"" + elementName + "\"][value=\"" + availableSelection[0] + "\"]")
      $(container_name).find(lastOption).prop("checked", true).prop "selected", true
      togglePreferredImage(lastOption)

    # Add has-selection style to parentFieldset if filter has option selected
    currentlySelected = $(':enabled:checked:not([value="ap-unselected"])', parentFieldset).length > 0
    if currentlySelected
      parentFieldset.addClass "has-selection"
    else
      parentFieldset.removeClass "has-selection"

    onlyOneSelection = $("input:radio:not(:disabled):not([style]) + label", parentFieldset).length is 1
    if onlyOneSelection
      parentFieldset.addClass "one-option"
    else
      parentFieldset.removeClass "one-option"

    # Check to see if all options are collapsed. If so, collapse the parent fieldset.
    if $("select, input:radio:not(:disabled):not([value=\"n_a\"])", parentFieldset).length > 0
      parentFieldset.show()
    else
      parentFieldset.hide()

    #XXX IE 8 shennanigans
    $("input:radio:checked", parentFieldset).next("label").find("> span").addClass "labelChecked"
    $("input:radio:not(:checked)", parentFieldset).next("label").find("> span").removeClass "labelChecked"

# Find a solution based on currently chosen properties
findSolution = (selected_fieldset) ->

  clearUI()
  available_solutions = []
  # Given there are solutions
  if AP.solutions.length > 0
    matchOn = {}
    # Create a registry of, and set the value for, each option value
    sanitizeKeys(AP.solutions[0]).forEach (e) ->
      #matchOn[e] = $(container_name + " select[name=\"" + e + "\"], input:radio[name=\"" + e + "\"]:checked").val()
      matchOn[e] = $(container_name).find(" select[name=\"" + e + "\"], input:radio[name=\"" + e + "\"]:checked").val()
    # Then filter the available solutions to configurations that meet existing criteria
    available_solutions = AP.solutions.filter (e) ->
      Object.keys(matchOn).reduce ((memo, key) ->

        memo and solutionEqualityTest(e[key], matchOn[key])
      ), true
    # Limit the remaining options based on the filtered list of solutions
    limitAvailableOptions(available_solutions,selected_fieldset)

    # If exactly one solution is left, hide the messages and build the parts lists
    if available_solutions.length is 1
      AP.finalSolution = available_solutions[0]
      $(container_name + " .ap-section-list .message").hide()
      $(container_name + " .ap-section-list .no-results").hide()
      # Enable Add Parts Button
      $('#ap-accept-button').prop('disabled',false)

      updatePartLists available_solutions[0]
    else
      # Otherwise clear out the parts lists and display the messages
      clearUI()
    getUnselectedList()
    document.getElementById('ap-help-button').setAttribute('href',$prodSubsetURL.concat($areq))

# Build parts lists for the given solution
updatePartLists = (solution) ->
  $maxCapacity = 0

  if solution
    # Clear previous full image display links - if any
    Shadowbox.clearCache()

    # For each part available, add it to the parts list if it's required for the solution
    iterator = 0
    AP.parts.forEach (e) ->
      insertIntoList $(container_name + " #ap-solution"), e if e.solution_id is solution.solution_id
      if e.capacity == null and e.solution_id is solution.solution_id
        $maxCapacity = Number.POSITIVE_INFINITY
      else
        $maxCapacity = $maxCapacity + e.capacity if e.solution_id is solution.solution_id
        iterator++ if e.solution_id is solution.solution_id
    currCapacity = $maxCapacity
    intervals = $maxCapacity/iterator
    # For each accessory, add it to the accessory list if it
    AP.accessories.forEach (e) ->
        # insertIntoConfigurableList $(container_name + " #ap-accessories"), e
      if e.solution_id is solution.solution_id
        insertIntoList $(container_name + " #ap-accessories"), e
    # If any parts or accessories exist, init the shadowbox
        $capacityMax = e.capacity
    AP.ca.forEach (e) ->
      if e.solution_id is solution.solution_id
        tsolution = jQuery.extend({}, solution)
        #solution.product_subset = e.nested_subset
        tsolution.product_subset = e.nested_subset
        insertIntoConfigurableList $(container_name + " #ap-accessories ul"), e, tsolution

    if AP.parts.length > 0 or AP.accesories.length > 0
      Shadowbox.setup 'a.ap-sb-link', {player: 'img'}
    if $maxCapacity != null and $maxCapacity != Number.POSITIVE_INFINITY and $maxCapacity > 0
      $('#config-container').addClass('capacity')
      capacityMessage()

capacityMessage = ->

  $('.capacity-message').empty().text("These Accessories are limited by a max capacity of " + $maxCapacity).removeClass('hidden').show()
    #firsthalf = $('.capacity-message').text().split('of')[0]
    #secondhalf = $('.capacity-message').text().split('of')[1]
    #if $.trim(secondhalf) == ''
    #  $('.capacity-message').removeClass('hidden').show().append($maxCapacity)
    #else
    #  fullstring = $('.capacity-message').text().replace(secondhalf, ' ' + $maxCapacity)
    #  $('.capacity-message').removeClass('hidden').show().text(fullstring)


insertIntoConfigurableList = (list, rtype, solution) ->
  $('.rs-spinner').removeClass('hidden')
  $.get "/product-configurator/rtype?rtype_id=" + rtype.part, (data) ->
    if data != ""
      list.prepend("<div href='/product-configurator/" + rtype.part + "?maxcap=" + currCapacity + "&amp;apiKey=12e218d8121bae8&amp;solution=" + encodeURIComponent(JSON.stringify(solution)) + "' class='test-button btn btn-success btn-block ap-button nested-access' id='+ "+rtype.button+"' data-remote='false' data-disable-with='Loading...' >" + "+ " + rtype.button + "</div>")
    $('.rs-spinner').addClass('hidden')
insertIntoList = (list, rtype) ->
  # Get the template markup from the list
  template = $('ul li.template', list)
  # Copy template for population and insertion
  listItem = template.clone(true)
  unit_capacity = Math.abs(parseInt(rtype.unit_capacity)) or 'N/A'
  # Determine min/max values
  if(rtype.min_quantity == null)
    min = -1
  else
    min = Math.abs(parseInt(rtype.min_quantity) or 1)

  if(rtype.max_quantity == null)
    max = -1
  else
    max = Math.max(Math.abs(parseInt(rtype.max_quantity) or 1), 1)

  quantity = $('.ap-quantity', listItem)
  quantity.data 'min', min
  quantity.data 'max', max
  quantity.data 'unitcapacity', unit_capacity
  quantity.val Math.abs(min)

  min_label = if min > -1 then min else "None"
  max_label = if max > -1 then max else "None"
  if unit_capacity == 'N/A'
    quantity.prop 'title', "min: #{min_label} max: #{max_label}"
    quantity.prop "min", min_label
    quantity.prop "max", max_label
  else
    quantity.prop 'title', "min: #{min_label} max: #{max_label} unit capacity: #{unit_capacity}"
    quantity.prop "min", min_label
    quantity.prop "max", max_label

  # Assign descriptive content
  $('.ap-label', listItem).text rtype.part
  $('.ap-description', listItem).text rtype.description or 'There is no description for this item.'

  # Check for image source
  if rtype.image
    # If source exists, assign the attributes and create the shadowbox link
    thumb = rtype.thumb
    src = rtype.image
    $('.ap-image img', listItem).prop 'src', thumb
    $('.ap-image a.ap-sb-link', listItem).prop('href', src)
    .prop('rel', "shadowbox[#{rtype.part}]")
    .prop('title', rtype.part)
  else
    $('.ap-image', listItem).remove()

  # Remove the template class from the template
  listItem.removeClass('template')
    # assign the part and type attributes
    .data('part', rtype.part)
    .data('type', rtype.type)
  # Add item to list
  $('ul', list).append(listItem)


submitFinalResult = ->

  # Get all the accessorires for processing
  parts = $(container_name + ' .ap-accessory-item .ap-quantity:visible, #ap-container .ap-part-item, .naccessory .ap-quantity:visible').closest('.ap-rtype-item')
  # Collect all parts, mapping their respective quantities from the list
  formatted_parts = $.map parts, (e, i) ->
    {
      quantity: parseInt($('.ap-quantity', $(e)).val())
      part_number: if $(e).data().part then  $(e).data().part else $(e).attr('id')
      type: if $(e).hasClass('ap-part-item') then 'final-part' else 'accessory'
    }

  # Fix issue where a null part is added

  AP.finalParts = $.grep formatted_parts, (item) ->
    item.part_number? && !isNaN(item.quantity)

  payload = {}
  payload["final_parts"] = AP.finalParts
  payload["final_solution"] = AP.finalSolution
  #AP.finalParts.push({final_solution: AP.finalSolution})
  # DEPRECATED Pass data to hidden div
  jsonString = JSON.stringify(payload)
  console.log jsonString
  $("#ap-final-result").empty().html jsonString
  # Call host function if exists
  parent.postMessage
    fn: "AddToProject"
    data: jsonString
    "*"
  parent.postMessage
    fn: "CloseEasySelector"
    "*"
  AddToProject jsonString if typeof AddToProject is "function"

getUnselectedList = ->
  count = []
  $(container_name + ' .ap-fieldset-fields').each (e) ->
    if !$('input:radio').is(':checked') or !$('option').is('selected')
      if !$(this).parent().hasClass('one-option')
        count.push($(this).context.id)
  $areq = '&areq='.concat(count.join(','))
  $areq

modifyDependantCount = (modifier) ->
  $dependantCount += modifier

  if ($dependantCount > 0 && $(container_name + ' #ap-reset-button').hasClass('reset-disable'))
    $(container_name + ' #ap-reset-button').removeClass('reset-disable').prop('disabled',false)

  if($dependantCount <= 0 && !$(container_name + ' #ap-reset-button').hasClass('reset-disable'))
    $(container_name + ' #ap-reset-button').addClass('reset-disable').prop('disabled',true)

solutionEqualityTest = (property, fieldValue) ->
  # Finds a match between a optionvalue and a field
  # Unseleted options return true (approximate match)
  (fieldValue is `undefined`) or (property is fieldValue) or (fieldValue is "ap-unselected")

sanitizeKeys = (object) ->
  $.grep Object.keys(object), (e, i) ->
    e isnt "solution_id" and e isnt "quantity"


$("ul").on "click", ".nested-access", ->
  $(".child-selector-container").empty().load $(this).attr("href")



getISODateTime = (d) ->
  # padding function
  s = (a, b) ->
    (1e15 + a + "").slice -b

  # default date parameter
  d = new Date()  if typeof d is "undefined"

  # return ISO datetime
  d.getFullYear() + "-" + s(d.getMonth() + 1, 2) + "-" + s(d.getDate(), 2) + " " + s(d.getHours(),
    2) + ":" + s(d.getMinutes(), 2) + ":" + s(d.getSeconds(), 2)

adv_init()

Shadowbox.init skipSetup: true
Shadowbox.setup 'a.ap-sb-link', player: 'img'

