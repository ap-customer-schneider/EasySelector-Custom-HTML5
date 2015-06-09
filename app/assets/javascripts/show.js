AP1 = window.AP2;
container_name1 = '.child-selector-container';

if (!Array.prototype.filter) {
    Array.prototype.filter = function(fn, context) {
        var i, length, result, value;
        i = void 0;
        value = void 0;
        result = [];
        length = void 0;
        length = this.length;
        i = 0;
        while (i < length) {
            if (this.hasOwnProperty(i)) {
                value = this[i];
                if (fn.call(context, value, i, this)) {
                    result.push(value);
                }
            }
            i++;
        }
        return result;
    };
}

if (!Array.prototype.forEach) {
    Array.prototype.forEach = forEach = function(callback, thisArg) {
        "use strict";
        var O, T, k, kValue, len, _results;
        T = void 0;
        k = void 0;
        kValue = void 0;
        O = Object(this);
        len = O.length >>> 0;
        if (arguments.length >= 2) {
            T = thisArg;
        }
        k = 0;
        _results = [];
        while (k < len) {
            if (k in O) {
                kValue = O[k];
                callback.call(T, kValue, k, O);
            }
            _results.push(k++);
        }
        return _results;
    };
}

if (!Array.prototype.map) {
    Array.prototype.map = function(callback, thisArg) {
        var A, O, T, k, kValue, len, mappedValue;
        T = void 0;
        A = void 0;
        k = void 0;
        O = Object(this);
        len = O.length >>> 0;
        if (thisArg) {
            T = thisArg;
        }
        A = new Array(len);
        k = 0;
        while (k < len) {
            kValue = void 0;
            mappedValue = void 0;
            if (k in O) {
                kValue = O[k];
                mappedValue = callback.call(T, kValue, k, O);
                A[k] = mappedValue;
            }
            k++;
        }
        return A;
    };
}

if ("function" !== typeof Array.prototype.reduce) {
    Array.prototype.reduce = function(callback, opt_initialValue) {
        "use strict";
        var index, isValueSet, length, value;
        index = void 0;
        value = void 0;
        length = this.length >>> 0;
        isValueSet = false;
        if (1 < arguments.length) {
            value = opt_initialValue;
            isValueSet = true;
        }
        index = 0;
        while (length > index) {
            if (this.hasOwnProperty(index)) {
                if (isValueSet) {
                    value = callback(value, this[index], index, this);
                } else {
                    value = this[index];
                    isValueSet = true;
                }
            }
            ++index;
        }
        return value;
    };
}

if (!Object.keys) {
    Object.keys = (function() {
        "use strict";
        var dontEnums, dontEnumsLength, hasDontEnumBug, hasOwnProperty;
        hasOwnProperty = Object.prototype.hasOwnProperty;
        hasDontEnumBug = !{
            toString: null
        }.propertyIsEnumerable("toString");
        dontEnums = ["toString", "toLocaleString", "valueOf", "hasOwnProperty", "isPrototypeOf", "propertyIsEnumerable", "constructor"];
        dontEnumsLength = dontEnums.length;
        return function(obj) {
            var i, prop, result;
            result = [];
            prop = void 0;
            i = void 0;
            for (prop in obj) {
                if (hasOwnProperty.call(obj, prop)) {
                    result.push(prop);
                }
            }
            if (hasDontEnumBug) {
                i = 0;
                while (i < dontEnumsLength) {
                    if (hasOwnProperty.call(obj, dontEnums[i])) {
                        result.push(dontEnums[i]);
                    }
                    i++;
                }
            }
            return result;
        };
    })();
}


var apViewport, _viewport;
AP1.finalParts = [];
AP1.optionDependants = [];
_viewport = $('head > meta[name=viewport]:last');
apViewport = $('<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/>');
if (_viewport.length > 0) {
    _viewport.replaceWith(apViewport);
} else {
    $('head').append(apViewport);
}


$(container_name1 + " input[value=\"n_a\"] + label").hide();
$(container_name1 + " input[value=\"n_a\"]").hide();
if ($(container_name1 + " input:radio").val() !== "n_a") {
    $(container_name1 + " .ap-fieldset-fields input:radio:last").parent("label").show();
} else {
    $(container_name1 + " .ap-fieldset-fields input:radio:last").parent("label").hide();
}
$productIdentifier = $("#ap-headline").data('id');
//document.getElementById('ap-help-button1').setAttribute('href', window.baseHelp.concat('&prod=').concat(product).concat('&subset=').concat(sku));
//$helpURL = window.baseHelp.concat('&prod=').concat(product);
$(container_name1 + ' #ap1-psubset-select').on({
    change: function() {
        var image, image_link, thumb, title;

        image_link = $(container_name1 + " .modal-header .ap-image > a.ap-sb-link");

        thumb = $('option:selected', this).data('thumb') || $("option[value='ap-unselected']", this).data('thumb');

        image = $('option:selected', this).data('image') || $("option[value='ap-unselected']", this).data('image');



        if (image) {
            image_link.prop('href', image);
        }



        if (thumb) {
            $('img', image_link).prop('src', thumb);
        }
        dependantCount = 0;
        //$('#overlaycontainerNest').hide();
        //$('#overlayOpacityNest').hide();
        $('#overlayOpacityNest').css('filter', 'alpha(opacity=20)');
        $('#overlayOpacityNest').fadeIn('fast');
        $('#overlaycontainerNest').fadeIn('fast');
        $('.test-button-partial').show();
        //$('#popup_box-nest').hide();
        return findSolution();
    }
});
$('#ap-close-button').on({
    click: function() {
        $('#overlaycontainer').hide();
        $('#overlayOpacity').hide();
        $('#overlayOpacity').css('filter', 'alpha(opacity=20)');
        $('#overlayOpacity').fadeIn('fast');
        return $('#overlaycontainer').fadeIn('fast');
    }
});
$('#ap-close-button-nest').on({
    click: function() {
        $('#config-container #ap-accessories ul').find('a[href*="product_subset%22%3A%22'+prod+'%22"]a[href*="'+product+'"]').text($('#config-container #ap-accessories ul').find('a[href*="product_subset%22%3A%22'+prod+'%22"]a[href*="'+product+'"]').attr('id'))
        $('#overlaycontainerNest2').hide();
        $('#overlayOpacityNest2').hide();
        $('#overlayOpacityNest2').css('filter', 'alpha(opacity=20)');
        $('#overlayOpacityNest2').fadeIn('fast');
        $('#overlaycontainerNest2').fadeIn('fast');

        return $('#popup_box-nest').show();
    }
});
$('.deleteconfirmbuttonyes').on({
    click: function() {
        return $(container_name1).modal('hide');
    }
});
$('.deleteconfirmbuttonno').on({
    click: function() {
        $('#overlaycontainer').fadeOut('fast');
        return $('#overlayOpacity').fadeOut('fast');
    }
});
$(container_name1 + ' input:radio + label').on({
    click: function(e) {
        var id;
        id = $(e.currentTarget).attr('for');
        if ($("html").hasClass("ie8")){
            $(container_name1 + " #" + id).click().change();
        }else{
            $(container_name1 + " #" + id).click()
        }
        return
    }
});
$(container_name1 + ' #ap-reset-button-nest').on({
    click: function(e) {
        resetForm();
        findSolution();
    }
});

$(container_name1 + ' .option-edit').on({
    click: function(e) {
        if($(this).closest('.ap-fieldset').find(".sent_in").length == 0){
            var id, option;
            id = $(e.currentTarget).attr('for');
            option = $("[data-option='" + id + "']");
            $(this).closest('.ap-fieldset').removeClass('edited');
            $(this).closest('.ap-fieldset').find( "span").removeClass('labelChecked');
            modifyDependantCount(-1);
            return enableSingleOption(option);
        }

    }
});
$(container_name1 + ' .ap-add-quantity').on({
    click: function(e) {
        return $(e.currentTarget).hide().siblings('.ap-quantity').show().focus();
    }
});
$(container_name1 + ' a.ap-sb-link').on({
    click: function(e) {
        return e.stopPropagation();
    }
});
$(container_name1 + ' .ap-subset-item').on({
    click: function(e) {
        var subset;

        subset = $(container_name1 + ' #ap1-psubset-select');

        $("option[name=\"" + subset.prop('name') + "\" ][value=\"" + $(this).data('value') + "\"]").prop("selected", true);
        $(container_name1 + ' #ap-psubset-container').show();
        return $(container_name1 + ' #ap1-psubset-select').change();
    }
});
$(container_name1 + ' .ap-quantity').on({
    focus: function(e) {
        var data, target;
        target = $(e.currentTarget);
        data = target.data();
        $differenceVal = 0;
        if (data.min === data.max && data.min !== -1 && target.closest(".ap-rtype-item").hasClass("ap-part-item")) {
            target.blur();
        }
        target.addClass('focused');
        if (target.hasClass('focusOn')) {
            return target.removeClass('focusOn');
        }
    },
    blur: function(e) {
        var capacity, data, maximum, minimum, target, val;
        target = $(e.currentTarget);
        data = target.data();
        val = Math.abs(parseInt(target.val()) || 0);

        if (target.parent().hasClass('ap-part-item')){
           currAcCapacity = (acIntervals * (target.val() - 1)) + $acCapacity;

        }
        if (target.closest('.ap-rtype-item').data().type === 'accessory' && val === 0) {
            target.val(Math.abs(data.min)).hide().siblings('.ap-add-quantity').show();
            target.parent().find('.ap-quant-remove').remove();
            target.removeClass('focused');
        } else {
            if (target.closest('.ap-rtype-item').attr('boxvalue')) {
                target.val(val);
                minimum = Math.abs(parseInt(target.closest('.ap-rtype-item').attr('min')));
                maximum = Math.abs(parseInt(target.closest('.ap-rtype-item').attr('max')));
                target.data('min', minimum);
                target.data('max', maximum);
                target.closest('.ap-rtype-item').removeAttr('boxvalue');
                target.closest('.ap-rtype-item').removeAttr('min');
                target.closest('.ap-rtype-item').removeAttr('max');
            }
            data = target.data();
            val = Math.max(val, data.min);
            if (data.max > -1) {
                val = Math.min(val, data.max);
            }
            target.val(Math.abs(val));
            if (target.closest('.ap-rtype-item').data().type === 'accessory')
                target.parent().append('<i class="fa fa-times ap-quant-remove" style="display:inline;margin-top:-30px;"></i>')

            //jQuery(e.currentTarget).next().fadeIn('fast');
        }
        capacity = 0;
        if (target.parent().hasClass('ap-part-item')){
            $(container_name1 + ' #ap-solution').find('li').each(function(i, li) {

                var $differenceVal, capacitySingle, unitCap;
                unitCap = 1;
                if ($(this).find('.ap-quantity').is(":visible") && $(this).find('.ap-quantity').data('unitcapacity') !== 'N/A' && $(this).find('.ap-quantity').val() !== 0 && ($maxCapacity > 0 || $maxCapacity === 0 ) ) {
                    capacitySingle = Math.abs(parseInt($(this).find('.ap-quantity').val()));

                    if ($(this).find('.ap-quantity').data('unitcapacity') > 1) {
                        unitCap = Math.abs(parseInt($(this).find('.ap-quantity').data('unitcapacity')));
                        capacitySingle = capacitySingle * unitCap;

                    }

                    if (typeof capacitySingle === 'number' && (capacitySingle % 1) === 0 && capacitySingle > 0 && $(this).find('.focused').length ) {
                        capacity = capacitySingle + capacity;


                    }
                }

            });
            if ($maxCapacity > 0 || $maxCapacity === 0) {
                if ($maxCapacity < capacity && !$(container_name1).find('#ap-solution').find('ul').find('.focusOn').length) {
                    cap = Math.abs(parseInt(target.parent().find(".ap-quantity").data("unitcapacity")));
                    $differenceVal = parseInt((capacity - $maxCapacity)/cap);
                    differenceValue(target, $differenceVal, cap, capacity, $maxCapacity);
                    $(this).find('.ap-quantity').addClass('focusOn');
                    $('#overlaycontainerCapacity').hide();
                    $('#overlayOpacityCapacity').hide();
                    $('#overlayOpacityCapacity').css('filter', 'alpha(opacity=20)');
                    $('#overlayOpacityCapacity').fadeIn('fast');
                    $('#overlaycontainerCapacity').fadeIn('fast');
                    $('#overlaycontainerCapacity').css('z-index', '99999');
                    return false;
                }
            }
        }else{
            $(container_name1 + ' #ap-accessories').find('li').each(function(i, li) {
                var $differenceVal, capacitySingle, unitCap;
                unitCap = 1;
                if ($(this).find('.ap-quantity').is(":visible") && $(this).find('.ap-quantity').data('unitcapacity') !== 'N/A' && $(this).find('.ap-quantity').val() !== 0 && (currAcCapacity > 0 || currAcCapacity === 0 ) ) {

                    capacitySingle = Math.abs(parseInt($(this).find('.ap-quantity').val()));

                    if ($(this).find('.ap-quantity').data('unitcapacity') > 1) {
                        unitCap = Math.abs(parseInt($(this).find('.ap-quantity').data('unitcapacity')));
                        capacitySingle = capacitySingle * unitCap;

                    }

                    if (typeof capacitySingle === 'number' && (capacitySingle % 1) === 0 && capacitySingle > 0 && $(this).find('.focused').length ) {
                        capacity = capacitySingle + capacity;

                    }
                }
            });
            if (currAcCapacity > 0 || currAcCapacity === 0) {
                if (currAcCapacity < capacity && !$(container_name1).find('#ap-accessories').find('ul').find('.focusOn').length) {
                    cap = Math.abs(parseInt(target.parent().find(".ap-quantity").data("unitcapacity")));
                    $differenceVal = parseInt((capacity - currAcCapacity)/cap);
                    differenceValue(target, $differenceVal, cap, capacity, currAcCapacity);
                    $(this).find('.ap-quantity').addClass('focusOn');
                    $('#overlaycontainerCapacity').hide();
                    $('#overlayOpacityCapacity').hide();
                    $('#overlayOpacityCapacity').css('filter', 'alpha(opacity=20)');
                    $('#overlayOpacityCapacity').fadeIn('fast');
                    $('#overlaycontainerCapacity').fadeIn('fast');
                    $('#overlaycontainerCapacity').css('z-index', '99999');
                    return false;
                }
            }
        }
    }
});

differenceValue = function (e, differenceVal, unitCap, capacity, $maxCapacity) {


    if((capacity - $maxCapacity)%unitCap === 0){
        e.val((e.val()) - differenceVal);
    }
    else {
        e.val((e.val()) - differenceVal - 1);

    }
    if(e.val() <= 0){
        //e.val(e.attr('data-min'));
        e.val(0);
        if(e.parent().hasClass('ap-part-item')){
            currAcCapacity = $acCapacity * e.val();
        }
        e.hide();
        e.siblings('.ap-add-quantity').show();
        e.parent().find('.ap-quant-remove').remove();
        //Check to see if item is a part

        $(container_name1 + ' #ap-accept-button').prop('disabled', true);
        $(container_name1 + ' #ap-accept-reset-button').prop('disabled', true);

    }

};

$('.deleteconfirmbuttoncapacity').on({
    click: function() {
        $('.focusOn').focus();
        $('#overlaycontainerCapacity').fadeOut('fast');
        return $('#overlayOpacityCapacity').fadeOut('fast');
    }
});


$(container_name1).on('click', '.ap-quant-remove', function(e) {
    if($(this).parent().hasClass('ap-part-item')){
        $(this).siblings('.ap-quantity').val( $(this).siblings('.ap-quantity').attr('data-min'));
        $(e.currentTarget).siblings('.ap-quantity').show();
        $(this).siblings('.ap-add-quantity').hide();


    }
    else{
        $(this).siblings('.ap-quantity').val( $(this).siblings('.ap-quantity').attr('data-min'));
        $(e.currentTarget).siblings('.ap-quantity').hide();
        $(this).siblings('.ap-add-quantity').show();
        $(this).parent().find('.ap-quant-remove').remove();
        //jQuery(e.currentTarget).fadeOut('fast');
        //
    }

    return //$(e.currentTarget).siblings('.ap-quantity').val($(this).siblings('.ap-quantity').attr('data-min'));
});



$(container_name1 + '.ap-quant-remove').on({
    mouseenter: function(e) {
        $(e.currentTarget).prev().css('border', '2px red solid');
        return $(e.currentTarget).next().show();
    },
    mouseleave: function(e) {
        return $(e.currentTarget).prev().css('border', 'none');
    }
});
$(container_name1 + " #ap-accept-button").click(function() {
    return submitFinalResult('accept');
});
$(container_name1 + " #ap-accept-reset-button").click(function(e) {
    e.preventDefault;
    return submitFinalResult('accept-reset');
});
$(container_name1).not(".sent_in").find("input:radio,select").on({
    change: function() {
        $(this).trigger('blur');
        var parentTarget;
        parentTarget = $(this).closest('.ap-fieldset');
        if ($(this).val() !== 'ap-unselected' ) {
            $(this).closest('.ap-fieldset').addClass('edited');
            if ($(this).attr('id') !== 'ap1-psubset-select') {
                togglePreferredImage($(this));
                if ($is_ie_lt9 = true) {
                    if ($(this).is('select')) {
                        modifyDependantCount(1);
                    } else {
                        modifyDependantCount(.5);
                    }
                } else {
                    modifyDependantCount(1);
                }
            }
        } else {
            $(this).closest('.ap-fieldset').removeClass('edited').removeClass('preferred');
            if ($(this).attr('id') !== 'ap1-psubset-select') {
                modifyDependantCount(-1);
            }
        }
        return findSolution(parentTarget);
    }
});


hideOption = function(option) {
    if ($(option).length > 0) {
        return $(option).each(function() {
            var parentName;
            if ($(this).is('option') && $(this).val() !== 'ap-unselected' && (!$(this).closest('select').hasClass('hidden-select')) && (!$(this).closest('select').is('#ap1-psubset-select'))) {
                parentName = $(this).closest('select').prop('name') + '-hidden';
                $(this).prop('disabled', true).prop('selected', false);
                $(this).detach();
                return $(container_name1 + ' select[name=\"' + parentName + '\"]').first().append($(this));
            }
        });
    }
};

showOption = function(option) {
    if ($(option).length > 0) {
        $(option).each(function() {
            var oldVal, parent, parentName;
            if ($(this).is('option') && $(this).val() !== 'ap-unselected' && $(this).closest('select').hasClass('hidden-select') && (!$(this).closest('select').is('#ap1-psubset-select'))) {
                parentName = $(this).closest('select').prop('name').replace('-hidden', '');
                $(this).prop('disabled', false);
                $(this).detach();
                parent = $(container_name1 + ' select[name=\"' + parentName + '\"]').first();
                oldVal = parent.val();
                parent.append($(this));
                parent.sort_select_box()
                parent.val(oldVal);
            }
        });
    }
};


$.fn.sort_select_box = function() {
    var my_options;
    my_options = $(this).find("option");
    if (my_options.length > 2) {
        my_options.sort(function(a, b) {
            if (a.id > b.id) {
                return 1;
            } else if (a.id < b.id) {
                return -1;
            } else {
                return 0;
            }
        });
    }
    $(this).empty().append(my_options);
};


resetForm = function() {
    AP1.finalParts = [];
    AP1.finalSolution = {};
    $(container_name1 + ':input').not(".sent_in").closest('.ap-fieldset').removeClass('edited').removeClass('preferred');
    //$(container_name1 + ' .ap-fieldset').not($(container_name1 + ' .ap-fieldset.ap-fieldset-fields.sent_in ')).removeClass('edited').removeClass('preferred');
    //$(container_name1 + ':input').not(".sent_in").siblings().find("span").removeClass('labelChecked');
    $(container_name1).find("span").removeClass('labelChecked');
    enableAllOptions();
    dependantCount = 0;
    return modifyDependantCount(0);
};

clearUI = function() {
    $(container_name1 + " .ap-section-list ul li:not(.template)").remove();
    $(container_name1 + " .ap-section-list .message").show();
    $(container_name1 + " .ap-section-list .no-results").hide();
    $(container_name1 + ' #ap-accept-reset-button').prop('disabled', true);
    $(container_name1 + " .capacity-message").addClass('hidden').hide();
    return $(container_name1 + ' #ap-accept-button').prop('disabled', true);
};

togglePreferredImage = function(elem) {
    if ($(elem).is('select') || $(elem).is('option')) {
        if ($(elem).first().data('is_preferred') || $(elem).find(':selected').first().data('is_preferred')) {
            return $(elem).closest('.ap-fieldset').addClass('preferred');
        } else {
            return $(elem).closest('.ap-fieldset').removeClass('preferred');
        }
    }
};

disableAllOptions = function() {
    $(container_name1).find('input:radio').prop("disabled", true).prop("checked", false);
    return hideOption($(container_name1).find('option'));
};

enableAllOptions = function() {
    AP1.optionDependants = [];
    $(container_name1).find('input:radio').not(".sent_in").prop("disabled", false).prop("checked", false);
    showOption($(container_name1).find('option'));
    $(container_name1 + " select:not(#ap1-psubset-select)").each(function(i, e) {

        return $(e).val("ap-unselected");
    });

    $('#overlaycontainerNest').hide();
    $('#overlayOpacityNest').hide();
    $('#overlayOpacityNest').css('filter', 'alpha(opacity=20)');
    $('#overlayOpacityNest').show()//fadeIn('fast');
    $('#overlaycontainerNest').show()//fadeIn('fast');
    $('.test-button-partial').show();
    $('#popup_box-nest').hide();
};

enableSingleOption = function(option) {
    var dependants, parentTarget;
    parentTarget = option.closest(container_name1 + ' .ap-fieldset');
    dependants = findDependants(parentTarget.data('name')) || [];
    if (dependants.length > 0) {
        dependants.forEach(function(e) {
            var elem;
            elem = $(container_name1 + (" input:radio[name='" + e.name + "'], ") + container_name1 + (" select[name='" + e.name + "']"));
            if(elem.siblings(".sent_in").length == 0){
                elem.prop("disabled", false).prop("checked", false);
                if (elem.is("select")) {
                    showOption($(container_name1 + ' select[name=\"' + elem.prop('name') + '-hidden\"]').find('option'));
                    elem.val("ap-unselected");
                    return togglePreferredImage(elem);
                }
            }
        });
        AP1.optionDependants = filterDependants(parentTarget.data('name'));
    }
    return findSolution();
};

findAvailableOptionsForSolutions = function(solutions) {
    var i, options, sanitizedKeys, sol;
    options = [];
    i = 0;
    while (i < solutions.length) {
        sol = solutions[i];
        sanitizedKeys = sanitizeKeys(sol);
        delete sanitizedKeys[$(container_name1 + ' #ap1-psubset-select').prop('name')];
        sanitizedKeys.forEach(function(e) {
            if ($(container_name1 + " input:radio[name=\"" + e + "\"][value=\"" + sol[e] + "\"]").length) {
                options.push($("input:radio[name=\"" + e + "\"][value=\"" + sol[e] + "\"]"));
            }
            if ($(container_name1 + " option[name=\"" + e + "\"][value=\"" + sol[e] + "\"]").length) {
                return options.push($("option[name=\"" + e + "\"][value=\"" + sol[e] + "\"]"));
            }
        });
        i++;
    }
    return options;
};

limitAvailableOptions = function(solutions, selected_fieldset) {
    var i, sanitizedKeys, sol;
    disableAllOptions();
    i = 0;
    while (i < solutions.length) {
        sol = solutions[i];
        sanitizedKeys = sanitizeKeys(sol);
        delete sanitizedKeys[$(container_name1 + ' #ap1-psubset-select').prop('name')];
        sanitizedKeys.forEach(function(e) {
            $(container_name1 + " input:radio[name=\"" + e + "\"][value=\"" + sol[e] + "\"]").prop("disabled", false);
            return showOption($(container_name1 + " option[name=\"" + e + "\"][value=\"" + sol[e] + "\"]"));
        });
        i++;
    }
    return selectLastOption(selected_fieldset);
};

isValidOption = function(option) {
    if (option.is("radio") && !option.prop('disabled')) {
        return true;
    } else if (option.is("option") && (!option.prop('disabled')) && (!option.parent().hasClass('hidden-select'))) {
        return true;
    } else {
        return false;
    }
};

matchDependants = function(dependantName) {
    return $.grep(AP1.optionDependants, function(item) {
        return item.name === dependantName;
    });
};

findDependants = function(dependantParentName) {
    return $.grep(AP1.optionDependants, function(item) {
        return item.dependsOn === dependantParentName;
    });
};

filterDependants = function(dependantParentName) {
    return $.grep(AP1.optionDependants, function(item) {
        return item.dependsOn !== dependantParentName;
    });
};

selectLastOption = function(selected_fieldset) {

    return $(".child-selector-container .ap-fieldset").each(function(i, e) {

        var availableSelection, currentlySelected, elementName, lastOption, obj, onlyOneSelection, parentFieldset;
        parentFieldset = $(e);
        elementName = parentFieldset.data("name");
        availableSelection = [];
        $(".child-selector-container [name='" + elementName + "']").each(function() {
            //$(container_name1 + " [name=\"" + elementName + "\"]").each(function() {
            var ref;
            ref = $(this);


            if (ref.is(":radio") && !(ref.is(":disabled"))) {
                return availableSelection.push(ref.val());

            } else {
                if (ref.is("option") && (!ref.is(":disabled")) && (ref.val() !== "ap-unselected")) {
                    return availableSelection.push(ref.val());
                }
            }
        });
        if (availableSelection.length === 1) {
            if (selected_fieldset) {
                obj = {
                    name: elementName,
                    value: availableSelection[0],
                    dependsOn: selected_fieldset.data('name')
                };
                if (matchDependants(elementName).length === 0) {
                    AP1.optionDependants.push(obj);
                }
            }
            lastOption = $(container_name1 + " [name=\"" + elementName + "\"][value=\"" + availableSelection[0] + "\"]");
            lastOption.prop("checked", true).prop("selected", true);
            togglePreferredImage(lastOption);
        }

        currentlySelected = $(':enabled:checked:not([value="ap-unselected"])', parentFieldset).length > 0;
        if (currentlySelected || parentFieldset.find(".sent_in").length > 0) {
            parentFieldset.addClass("has-selection");
        } else {
            parentFieldset.removeClass("has-selection");
        }
        onlyOneSelection = $(container_name1 + " input:radio:not(:disabled):not([style]) + label", parentFieldset).length === 1;
        if (onlyOneSelection) {
            parentFieldset.addClass("one-option");
        } else {
            parentFieldset.removeClass("one-option");

        }

        if ($(".child-selector-container select,input:radio:not(:disabled):not([value=\"n_a\"])", parentFieldset).length > 0) {
            parentFieldset.show();
        } else {
            parentFieldset.hide();
        }

        $(".child-selector-container").find("input:radio:checked", parentFieldset).next("label").find("> span").addClass("labelChecked");
        //$(container_name1 + " input:radio:checked", parentFieldset).next("label").find("> span").addClass("labelChecked");
        return $(container_name1 + " input:radio:not(:checked)", parentFieldset).next("label").find("> span").removeClass("labelChecked");

    });
};

findSolution = function(selected_fieldset) {
    var available_solutions, matchOn;
    clearUI();
    available_solutions = [];
    if (AP1.solutions.length > 0) {
        matchOn = {};
        sanitizeKeys(AP1.solutions[0]).forEach(function(e) {
            return matchOn[e] = $(".child-selector-container select[name=\"" + e + "\"], .child-selector-container input:radio[name=\"" + e + "\"]:checked").val();
        });
        available_solutions = AP1.solutions.filter(function(e) {
            return Object.keys(matchOn).reduce((function(memo, key) {
                return memo && solutionEqualityTest(e[key], matchOn[key]);
            }), true);
        });

        limitAvailableOptions(available_solutions, selected_fieldset);
        if (available_solutions.length === 1) {
            AP1.finalSolution = available_solutions[0];
            $(container_name1 + " .ap-section-list .message").hide();
            $(container_name1 + " .ap-section-list .no-results").hide();
            $(container_name1 + ' #ap-accept-button').prop('disabled', false);
            $(container_name1 + ' #ap-accept-reset-button').prop('disabled', false);
            updatePartLists(available_solutions[0]);
        } else {
            clearUI();
        }
        getUnselectedList();
        //return document.getElementById('ap-help-button').setAttribute('href', $prodSubsetURL.concat(areq));
        return document.getElementById('ap-help-button1').setAttribute('href', window.baseHelp.concat('&prod=').concat(product).concat('&subset=').concat(sku).concat(areq));
    }
};

updatePartLists = function(solution) {
    if (solution) {
        Shadowbox.clearCache();
        var iterator = 0;
        AP1.parts.forEach(function(e) {
            if (e.solution_id === solution.solution_id) {
                $acCapacity = $acCapacity + e.capacity
                iterator++;
                insertIntoList($(container_name1 + " #ap-solution"), e, 0);
            }


        });

        acIntervals = $acCapacity/iterator;
        $('#config-container').find('#ap-accessories li').each(function(index) {
            var blahblah = $(this).find('.ap-label').text();
            $accessoriesOriginal.push(blahblah);
        });

        AP1.accessories.forEach(function(e) {
            if (e.solution_id === solution.solution_id) {
                var $j = 0;
                if ( $.inArray(e.part, $accessoriesOriginal) > -1 ) {
                    return insertIntoList($(container_name1 + " #ap-accessories"), e, 0);
                } else {
                    return insertIntoList($(container_name1 + " #ap-accessories"), e, 0);
                }
            }
        });
        if (AP1.parts.length > 0 || AP1.accesories.length > 0) {
            Shadowbox.setup('a.ap-sb-link', {
                player: 'img'
            });
        }

    }
};

insertIntoList = function(list, rtype, disabled) {
    var listItem, max, max_label, min, min_label, quantity, src, template, thumb, unit_capacity;
    template = $('ul li.template', list);
    listItem = template.clone(true);
    unit_capacity = Math.abs(parseInt(rtype.unit_capacity)) || 'N/A';

    if (rtype.min_quantity === null) {
        min = -1;
    } else {
        min = Math.abs(parseInt(rtype.min_quantity) || 1);
    }
    if (rtype.max_quantity === null) {
        max = -1;
    } else {
        max = Math.max(Math.abs(parseInt(rtype.max_quantity) || 1), 1);
    }
    quantity = $('.ap-quantity', listItem);
    quantity.data('min', min);
    quantity.data('max', max);
    quantity.data('unitcapacity', unit_capacity);
    quantity.val(Math.abs(min));
    min_label = min > -1 ? min : "None";
    max_label = max > -1 ? max : "None";
    quantity.prop('title', "min: " + min_label + " max: " + max_label + " unit capacity: " + unit_capacity);

    $('.ap-label', listItem).text(rtype.part);
    $('.ap-description', listItem).text(rtype.description || 'There is no description for this item.');
    if (disabled == 1) {
        listItem.removeClass('template').addClass('disabled-text').addClass('disabled-accessory').data('part', rtype.part).data('type', + rtype.type);

    } else{
        listItem.removeClass('template').data('part', rtype.part).data('type', rtype.type);
    }
    if(rtype.type == "accessory"){
        listItem.find('.ap-quantity').hide();
        listItem.find('.ap-add-quantity').show();
        listItem.addClass('.accessory');
        listItem.data('part', rtype.part).data('type', rtype.type)


    }else{
        listItem.find('.ap-quantity').show();
        listItem.find('.ap-add-quantity').hide();
        var selector = listItem.find('.ap-label').text();

    }
    listItem.attr('title', rtype.part)
    $('ul', list).append(listItem);
    if(rtype.type != "accessory"){
      listItem.append('<i class="fa fa-times ap-quant-remove" style="display:inline;margin-top:-30px;"></i>');
      listItem.find(".ap-quant-remove").hide();
      listItem.find('.ap-quantity').focus();
    }

    return $('.disabled-text').show();
};

submitFinalResult = function(addButton) {
    $(container_name1).find('#ap-accessories, #ap-solution').find('li').each(function( index ) {
        if (index != 0) {

            var boxVal = ($(this).find('.ap-quantity').val());
            var maxQuant = Math.abs(parseInt($(this).find('.ap-quantity').data('max')));
            var minQuant = Math.abs(parseInt($(this).find('.ap-quantity').data('min')));
            var unitCap = Math.abs(parseInt($(this).find('.ap-quantity').data('unitcapacity')));
            var liElement = ($( this ).html() );
            var target = $(this);

            var mainSelectorElement = $(this).find('.ap-label').text();
            $('#config-container').find('#ap-solution, #ap-accessories').find('li').each(function() {
                if ($(this).find('.ap-label').text() == mainSelectorElement){
                    var parentContainerValue = Math.abs(parseInt($(this).find('.ap-quantity').val()));
                    var innerBoxValue = Math.abs(parseInt(boxVal));
                    var subtractOne = parentContainerValue + innerBoxValue;
                    if (subtractOne > maxQuant) {
                        subtractOne = maxQuant;
                    }
                    $(this).find('.ap-quantity').val(Math.abs(parseInt(subtractOne)));


                    return false;
                } else {
                    if(boxVal > 0 && $(target).find('.ap-quantity').is(':visible')){
                        $maxCapacity = $maxCapacity - (boxVal*unitCap);

                        console.log(target);
                        console.log(target.hasClass('ap-accessory-item'));

                        if(target.hasClass('ap-accessory-item')){
                            liElement = ('<li class="ap-rtype-item nested naccessory" id="' + mainSelectorElement + '" boxValue="' + boxVal  + '" unitcapacity="' + unitCap + '" ' + 'min="' + minQuant + '" max="' + maxQuant + '"> ').concat(liElement);
                        }else{
                            liElement = ('<li class="ap-rtype-item nested naccessory" id="' + mainSelectorElement + '" boxValue="' + boxVal  + '" unitcapacity="' + unitCap + '" ' + 'min="' + minQuant + '" max="' + maxQuant + '"> ').concat(liElement);

                        }
                        liElement = liElement.concat('</li>');
                        $('#config-container #ap-accessories ul').find('div[href*="product_subset%22%3A%22'+prod+'%22"]div[href*="'+product+'"]').before(liElement);
                        $('#config-container #ap-accessories ul').find('div[href*="product_subset%22%3A%22'+prod+'%22"]div[href*="'+product+'"]').text($('#config-container #ap-accessories ul').find('div[href*="product_subset%22%3A%22'+prod+'%22"]div[href*="'+product+'"]').attr('id'));
                        var boxedVal = $('#config-container #' + mainSelectorElement).attr('boxValue');
                        //$('#config-container #' + mainSelectorElement + ' .ap-quantity').val(Math.abs(parseInt(boxVal)));
                        $('#config-container #ap-accessories ul').find('div[href*="product_subset%22%3A%22'+prod+'%22"]div[href*="'+product+'"]').prev().find('.ap-quantity').val(Math.abs(parseInt(boxVal)))

                        $('#config-container #ap-accessories ul').find('li:contains("'+mainSelectorElement+'")').find('.ap-quantity').focus()
                    }

                    //$('#config-container #ap-accessories ul').find('a[href*="product_subset%22%3A%22'+prod+'%22"]a[href*="'+product+'"]').text($('#config-container #ap-accessories ul').find('a[href*="product_subset%22%3A%22'+prod+'%22"]a[href*="'+product+'"]').attr('id'));

                    return false;
                }

            });

        };
    });
    if (addButton == 'accept') {

        $('#overlaycontainerNest2').fadeOut('fast')
        $('#overlayOpacityNest2').fadeOut('fast')
        $('#overlaycontainerNest').fadeOut('fast')
        $('#overlayOpacityNest').fadeOut('fast')
        var liSize = $(container_name1).find('#ap-accessories, #ap-solution').find('li').size() - 1;
        resetForm();
        clearUI();
        findSolution();
        // $('#config-container #justAppended' + liSize + ' .ap-quantity').focus();
    } else if (addButton == 'accept-reset') {
        $('.capacity-message').addClass('hidden').hide();
        resetForm();
        clearUI();
        findSolution();
    }

};
//Method for help url to loop and check for radio or selects that have been selected
getUnselectedList = function() {
    var count;
    count = [];
    $(container_name1 + ' .ap-fieldset-fields').each(function(e) {
        if (!$('input:radio').is(':checked') || !$('option').is('selected')) {
            if (!$(this).parent().hasClass('one-option')) {
                return count.push($(this).context.id);
            }
        }
    });
    areq = '&areq='.concat(count.join(','));
    return areq;
};

modifyDependantCount = function(modifier) {
    dependantCount += modifier;
    if (dependantCount > 0 && $(container_name1 + ' #ap-reset-button-nest').hasClass('reset-disable')) {
        $(container_name1 + ' #ap-reset-button-nest').removeClass('reset-disable').prop('disabled', false);
    }
    if (dependantCount <= 0 && !$(container_name1 + ' #ap-reset-button-nest').hasClass('reset-disable')) {
        return $(container_name1 + ' #ap-reset-button-nest').addClass('reset-disable').prop('disabled', true);
    }
};

solutionEqualityTest = function(property, fieldValue) {
    return (fieldValue === undefined) || (property === fieldValue) || (fieldValue === "ap-unselected");
};

sanitizeKeys = function(object) {
    return $.grep(Object.keys(object), function(e, i) {
        return e !== "solution_id" && e !== "quantity";
    });
};

getISODateTime = function(d) {
    var s;
    s = function(a, b) {
        return (1e15 + a + "").slice(-b);
    };
    if (typeof d === "undefined") {
        d = new Date();
    }
    return d.getFullYear() + "-" + s(d.getMonth() + 1, 2) + "-" + s(d.getDate(), 2) + " " + s(d.getHours(), 2) + ":" + s(d.getMinutes(), 2) + ":" + s(d.getSeconds(), 2);
};


$(container_name1 + '  #ap1-psubset-select').change();



