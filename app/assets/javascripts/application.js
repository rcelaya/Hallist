// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery.min
//= require jquery/jquery-ui-1.8.17.custom.min
//= require jquery_ujs
//= require underscore
//= require bootstrap
//= require bootstrap-scroll-modal
//= require bootstrap-transition
//= require backbone
//= require backbone_rails_sync
//= require backbone_datalink
//= require backbone/arto
//= require jquery.infinitescroll.min
//= require jquery.masonry.min
//= require chosen.jquery.min
//= require jquery.creditCardValidator
//= require jquery.jgrowl.mini
//= require jquery.validate.min
//= require scroll-down
//= require jquery.resize.min
//= require bootstrap-datepicker
//= require fb/facebook
//= require conekta
//= require updateImage

var $window = $(window);
var Arto = Arto || {}

Arto.popovers = {
    initialize: function () {
        this.cart();
    },

    cart: function () {
        this.cartPopover = $("a.cart-link").popover({
            trigger: 'manual',
            placement: 'bottom',
            content: $('#cart-popover-content').html(),
            html: true,
            template: '<div class="popover cart"><div class="arrow arrow-gray"></div><div class="popover-inner"><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div></div>'
        }).click(function (e) {
                e.preventDefault();
                $(this).popover('toggle');
            });
    },

    closeCart: function () {
        this.cartPopover.popover('hide')
    }
}

Arto.modals = {



}

titleResize = function () {
    marginCalculation = (($(window).width() - $('.span12').width()) / 2);
    $('#content h2.large, #content h3.large, #content h4.large, #content h5.large').each(function (index, value) {
        $(value).css('margin-left', "-" + marginCalculation + "px");
    });

    $('h2.large.custom-width').each(function (index, value) {
        widthCalculation = marginCalculation + 210;
        $(value).css('margin-left', "-" + marginCalculation + "px").css('width', widthCalculation);

    });

}


$(document).ready(function () {
    Arto.popovers.initialize();
    titleResize();

    $(document).on('click', '.close-artwork-button', function (event) {
        $('#artwork-details-modal').modal('hide');
    });

});

$(function () {
    $('.add-to-collection-button').live('click', function (event) {
        event.preventDefault();
        productId = $(this).data('product-id');

        $('#artwork-details-modal').modal('hide');
        Arto.popovers.closeCart();

        if (window.current_user) {
            if($(this).data('collection-action') == 'hallit'){
              productId = $(this).data('product-id');
              if (productId) {
                $('form#add-to-collection-form').attr('action', '/products/' + productId + '/collection_cart_items');
                $('#add-collection-product-id').val(productId);
              }
              $('#add-to-collection-modal').modal('show');
            } else {
              //url = '/collections/'+ $(this).data('product-id');
              url = '/products/' + $(this).data('product-id') + '/collection_cart_items/' + $(this).data('product-id');
              type = 'DELETE'
              $.ajax({
                type: type,
                url: url,
                success: function (data) {
                    referencia = window.location.href;
                    if(referencia.indexOf("collections") == -1 ){
                        collectionButton = $('div.add-to-collection-button[data-product-id=' + data.product_id + ']');
                        collectionButton.data('collection-action', data.collection_action);
                        collectionButton.find('span').html(data.collection_action);
                        collectionButton.removeClass('unhallit');
                    } else {
                        $('div.add-to-collection-button[data-product-id=' + data.product_id + ']').parent().parent().remove();
                        window.location.href = '/collections/' + data.collection_id
                    }
                }
              });
            }
        } else {
            openLoginModal();
        }
    });

    $('#close-button').click(function (event) {
        event.preventDefault()
        $('.modal').modal('hide');
    });

    $('#create-to-collection').live('click', function (event) {
        event.preventDefault();

        if (_.isEmpty($('#add-to-collection-modal form#new_collection input#collection_name').val()) && !_.isEmpty($('#add-to-collection-modal form #collection_id'))) {
            formUrl = $('form#add-to-collection-form').attr('action');
            data = {collection_id: $('#add-to-collection-modal form select').val()};
        } else {
            createForm = $('#add-to-collection-modal form#new_collection')
            formUrl = createForm.attr('action');
            data = {
                product_id: createForm.find('#add-collection-product-id').val(),
                collection: {
                    name: createForm.find('#collection_name').val(),
                    description: createForm.find('#collection_description').val()
                }
            }
        }
        console.log(formUrl);
        $.ajax({
            type: 'POST',
            url: formUrl + '.json',
            data: data,
            success: function (data) {
                $('.modal').modal('hide');
                collectionButton = $('div.add-to-collection-button[data-product-id=' + data.product_id + ']');
                collectionButton.data('collection-action', data.collection_action);
                collectionButton.find('span').html(data.collection_action);
                collectionButton.addClass('unhallit');
            }
        });
    });

    $('#create-collection-modal #create-collection').live('click', function (event) {
        event.preventDefault();
        createForm = $('#create-collection-modal form#new_collection').submit();
    });
});

$(function () {
    $('.like-button').live('click', function (event) {
        event.preventDefault();
        if (window.current_user) {
            url = '/products/' + $(this).data('product-id') + '/likes';
            type = ($(this).data('like-action') == 'like') ? 'POST' : 'DELETE'
            $.ajax({
                type: type,
                url: url,
                success: function (data) {

                    likeButton = $('div.like-button[data-product-id=' + data.product_id + ']');
                    likeButton.data('like-action', data.like_action);

                    likeButton.find('span').html(data.like_action);
                }
            });
        } else {
            openLoginModal();
        }
    });
});

$(function () {
    $('.login-link').click(function (event) {
        event.preventDefault();
        openLoginModal();
    });
});


$(function () {
    $('#banners_0').click(function (event) {
        event.preventDefault();
        openVideoModal();
        $('#video-modal-hallsit')[0].load();
        $('#video-modal-hallsit')[0].play();
    });
});

$(function () {
    $('.add-checkout').click(function (event) {
        event.preventDefault();
        if (window.current_user) {
        } else {
            openLoginModal();
        }
    });
});

$(function () {
    $('.pago').click(function (event) {
        event.preventDefault();
        openCheckoutModal();
    });
});

$(function () {
    $('#terms').click(function (event) {
        event.preventDefault();
        openTermsModal();
    });
});

$(function () {
    window.onresize = function (event) {
        $container = $('#products-list');
        $container.masonry('destroy');
        $container.masonry({isFitWidth: true});
        resizeWidth = $container.width();
        $('.carousel-container').width($container.width);
        $('.footer-message').width($container.width());
        titleResize();

        if (window.resize == false) {
            resizeSize = $(window).width() - 40;
            $('#main-header-row').width(resizeSize);
            $('#filter-header-row-container').width(resizeSize);
            $('.footer-message').width(resizeSize);
        }

        if($('#banners_0')[0] && $('#banners_1')[0]){
        if ($(window).width() <= 320){
            $('#publicidad-header').hide();
            $('#nombre-publicidad').hide();
            $('#carousel-control-right').addClass('move-control-right');
            $('#banners_0')[0].src = '/assets/banners/banner0_320.png';
            $('#banners_1')[0].src = '/assets/banners/banner1_320.png';
        } else if($(window).width() <= 480) {
            $('#publicidad-header').hide();
            $('#nombre-publicidad').hide();
            $('#carousel-control-right').removeClass('move-control-right')
            $('#banners_0')[0].src = '/assets/banners/banner0_480.png';
            $('#banners_1')[0].src = '/assets/banners/banner1_480.png';
        } else if($(window).width() <= 620){
            $('#publicidad-header').hide();
            $('#nombre-publicidad').hide();
            $('#carousel-control-right').removeClass('move-control-right')
            $('#banners_0')[0].src = '/assets/banners/banner0_620.png';
            $('#banners_1')[0].src = '/assets/banners/banner1_620.png';
        } else if($(window).width() <= 767){
            $('#publicidad-header').show();
            $('#nombre-publicidad').show();
            $('#carousel-control-right').removeClass('move-control-right')
            $('#banners_0')[0].src = '/assets/banners/banner0_767.png';
            $('#banners_1')[0].src = '/assets/banners/banner1_767.png';
        } else if($(window).width() <= 990){
            $('#publicidad-header').show();
            $('#nombre-publicidad').show();
            $('#carousel-control-right').removeClass('move-control-right');
            $('#banners_0')[0].src = '/assets/banners/banner0_990.png';
            $('#banners_1')[0].src = '/assets/banners/banner1_990.png';
        } else if($(window).width() <= 1180){
            $('#publicidad-header').show();
            $('#nombre-publicidad').show();
            $('#carousel-control-right').removeClass('move-control-right')
            $('#banners_0')[0].src = '/assets/banners/banner0_1200.png';
            $('#banners_1')[0].src = '/assets/banners/banner1_1200.png';
        }
        }
    }

    $('#artwork-details-modal').on('hidden', function () {
        // Backbone.history.navigate("");
        window.history.back();
    });

    $('#follow-link').live('ajax:beforeSend', function () {
        if (window.current_user == null) {
            openLoginModal()
            return false;
        }
    });

    $('.carousel .item a').click(function (event) {
        href = $(event.currentTarget).attr('href');

        if (!event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey) {
            event.preventDefault()
            url = href.replace(/^\//, '').replace('\#\!\/', '')
            window.router.navigate(url, { trigger: true })
            return false
        }
    });

    $('#products, #collections, #hallists, #artists').resize(function () {
        if ($(window).width() < $(this).width()) {
            resizeWidth = $('#content').width() - 20;
        } else {
            resizeWidth = $(this).width() - 20;
        }
        if (window.resize) {
            $('#main-header-row').width(resizeWidth);
            $('#filter-header-row-container').width(resizeWidth);
            $('#responsive-title').width(resizeWidth);
            if ($(window).width() > 400)
                $('.carousel-container').width(resizeWidth);
        }
        $('.footer-message').width(resizeWidth);
    });

    $('.more-artworks').live('click', function (event) {
        event.preventDefault();
        profile_id = $(this).data('profile-id');
        window.router.products.fetchNextProfile(profile_id);
    });

    $('.more-collections').live('click', function (event) {
        event.preventDefault();
        profile_id = $(this).data('profile-id');
        $.ajax({
            url: '/profile/' + profile_id + '/collections',
            data: {page: window.profile_collections_page},
            success: function (data) {
                console.log(data);
            }
        });
    });

    $('.search-contaniner a.search-link').live('click', function (event) {
        event.preventDefault();
        $('nav .search').hide(500);
        searchLink = $(this).data('search-link');

        if (searchLink == 'halls' && $('nav .search.search-hallist').is(':hidden')) {
            $('nav .search.search-hallist').show(500);
        } else if (searchLink == 'artists' && $('nav .search.search-artist').is(':hidden')) {
            $('nav .search.search-artist').show(500);
        }
    });
});

$(function () {

    // View in a room feature

    $('.preview-link').live('click', function (event) {
        event.preventDefault();
        image = $('.artwork-image');
        image_container = $('.img-product');
        small_image = $('.small-image');
        preview = $('.preview');

        image_height = image.height();

        var column_preview = $(this).parent().parent().children('.medidas').children().children()[0].innerText,
        medida = column_preview.match(/(\d+) x (\d+)/),
        width = medida[1],
        height = medida[2];

        if (small_image.data('artwork-measures') == 'inch' || _.isEmpty(small_image.data('artwork-measures'))) {
            small_image.css('height', (height * 2.5));
            small_image.css('width', (width * 2.5));
        } else {
            small_image.css('height', height);
            small_image.css('width', width);
        }

        small_image.draggable();
        preview.show(500);
        $('.social-buttons-container').hide(500);
        image_container.hide(500);
    });

    $('.preview-close').live('click', function (event) {
        event.preventDefault();

        image_container = $('.img-product');
        preview = $('.preview');

        preview.hide(500);
        image_container.show(500);
        $('.social-buttons-container').show(500);
    });

});

$(function () {
    $('.social-buttons-container > .social-button-trigger').live('click', function (event) {
        event.preventDefault();
        window.open($(this).data('url'), this.target, 'width=600,height=400');
        return false;
    });

    if (window.resize == false) {
        resizeSize = $(window).width() - 40;
        $('#main-header-row').width(resizeSize);
        $('#filter-header-row-container').width(resizeSize);
        $('#responsive-title').width(resizeSize);
        $('.footer-message').width(resizeSize);
    }

    $('.no-collection > .create-collection').live('click', function (event) {
        event.preventDefault();
        $('#create-collection-modal').modal();
    });

    $('.link-menu-iphone').live('click', function () {
        $('body').toggleClass('iphone-menu-visible');
        if (window.current_user == null)
            $('body').toggleClass('no-user');
    });

    $('.checkout-button').click(function (event) {
        event.preventDefault();
        $('.edit_order input').removeClass('fail');

        shippingAddressComplete = true;
        if (_.isEmpty($('#order_ship_address_attributes_first_name').val())) {
            shippingAddressComplete = false;
            $('#order_ship_address_attributes_first_name').addClass('fail');
        }

        if (_.isEmpty($('#order_ship_address_attributes_last_name').val())) {
            shippingAddressComplete = false;
            $('#order_ship_address_attributes_last_name').addClass('fail');
        }

        if (_.isEmpty($('#order_ship_address_attributes_address1').val())) {
            shippingAddressComplete = false;
            $('#order_ship_address_attributes_address1').addClass('fail');
        }

        if (_.isEmpty($('#order_ship_address_attributes_country').val())) {
            shippingAddressComplete = false;
            $('#order_ship_address_attributes_country').addClass('fail');
        }
        /*if(_.isEmpty($('#order_ship_address_attributes_state').val())) {
         shippingAddressComplete = false;
         $('#order_ship_address_attributes_state').addClass('fail');
         }  */

        if (_.isEmpty($('#order_ship_address_attributes_city').val())) {
            shippingAddressComplete = false;
            $('#order_ship_address_attributes_city').addClass('fail');
        }

        if (_.isEmpty($('#order_ship_address_attributes_zip_code').val())) {
            shippingAddressComplete = false;
            $('#order_ship_address_attributes_zip_code').addClass('fail');
        }

        if (shippingAddressComplete == false) {
            event.preventDefault();
            event.stopPropagation();
        }
    });
});


$(document).ready(function () {
    $('input[id*=order_ship_address_attributes], select[id*=order_ship_address_attributes]').live('change', function (event) {
        event.preventDefault();
        var shippingAddressComplete = true;

        if (_.isEmpty($('#order_ship_address_attributes_first_name').val())) {
            shippingAddressComplete = false;
        }

        if (_.isEmpty($('#order_ship_address_attributes_last_name').val())) {
            shippingAddressComplete = false;
        }

        if (_.isEmpty($('#order_ship_address_attributes_address1').val())) {
            shippingAddressComplete = false;
        }

        if (_.isEmpty($('#order_ship_address_attributes_country').val())) {
            shippingAddressComplete = false;
        }

        /*if(_.isEmpty($('#order_ship_address_attributes_state').val())) {
         shippingAddressComplete = false;
         } */

        if (_.isEmpty($('#order_ship_address_attributes_city').val())) {
            shippingAddressComplete = false;
        }

        if (_.isEmpty($('#order_ship_address_attributes_zip_code').val())) {
            shippingAddressComplete = false;
        }

        if (shippingAddressComplete) {
            $('.checkout-button').removeClass('checkout-disabled')
        } else {
            $('.checkout-button').addClass('checkout-disabled')
        }
    });
});


function openLoginModal() {
    $('#artwork-details-modal').modal('hide');
    Arto.popovers.closeCart();
    $('#login-modal').modal();
}

function openCheckoutModal() {
    $('#artwork-details-modal').modal('hide');
    Arto.popovers.closeCart();
    $('#checkout-modal').modal();
}

function openTermsModal() {
    $('#artwork-details-modal').modal('hide');
    Arto.popovers.closeCart();
    $('#terms-modal').modal();
}

function openVideoModal() {
    $('#artwork-details-modal').modal('hide');
    Arto.popovers.closeCart();
    $('#video-modal').modal();
}

$('#about-profile').live('click', function (event) {
    event.preventDefault();

    $('#followers-profile').removeClass('selected');
    $('#followings-profile').removeClass('selected');

    $('#followers').hide(500);
    $('#followings').hide(500);
    $('#about').toggle(500);

    $(this).toggleClass('selected');
});

$('#followers-profile').live('click', function (event) {
    event.preventDefault();

    $('#about-profile').removeClass('selected');
    $('#followings-profile').removeClass('selected');


    $('#about').hide(500);
    $('#followings').hide(500);
    $('#followers').toggle(500);

    $(this).toggleClass('selected');
});

$('#followings-profile').live('click', function (event) {
    event.preventDefault();

    $('#about-profile').removeClass('selected');
    $('#followers-profile').removeClass('selected');

    $('#followers').hide(500);
    $('#about').hide(500);
    $('#followings').toggle(500);

    $(this).toggleClass('selected');
});

$(document).ready(function () {
    var $win = $(window);

    $win.scroll(function () {
        if ($win.height() + $win.scrollTop() == $(document).height()) {
            $('div.footer-gif').css({})
        }
    });

    // hide #back-top first
    $("#back-top").hide();

});


$(document).ready(function () {

    $('.list-icon').toggle(function () {

            $('footer').animate({

                height: '170px'
            });


            $('.footer-message').css('display', 'block');
            $('.arto-sign').hide('slow');
        },

        function () {

            $('footer').animate({

                height: '20px'

            });

            $('.footer-message').css('display', 'none');
            $('.arto-sign').show();

        }

    );


});

/*
 * Project: Twitter Bootstrap Hover Dropdown
 * Author: Cameron Spear
 * Contributors: Mattia Larentis
 *
 * Dependencies?: Twitter Bootstrap's Dropdown plugin
 *
 * A simple plugin to enable twitter bootstrap dropdowns to active on hover and provide a nice user experience.
 *
 * No license, do what you want. I'd love credit or a shoutout, though.
 *
 * http://cameronspear.com/blog/twitter-bootstrap-dropdown-on-hover-plugin/
 */
;
(function ($, window, undefined) {
    // outside the scope of the jQuery plugin to
    // keep track of all dropdowns
    var $allDropdowns = $();

    // if instantlyCloseOthers is true, then it will instantly
    // shut other nav items when a new one is hovered over
    $.fn.dropdownHover = function (options) {

        // the element we really care about
        // is the dropdown-toggle's parent
        $allDropdowns = $allDropdowns.add(this.parent());

        return this.each(function () {
            var $this = $(this).parent(),
                defaults = {
                    delay: 500,
                    instantlyCloseOthers: true
                },
                data = {
                    delay: $(this).data('delay'),
                    instantlyCloseOthers: $(this).data('close-others')
                },
                settings = $.extend(true, {}, defaults, options, data),
                timeout, subTimeout;

            $this.hover(function () {
                if (shouldHover()) {
                    if (settings.instantlyCloseOthers === true)
                        $allDropdowns.removeClass('open');

                    window.clearTimeout(timeout);
                    $(this).addClass('open');
                }
            }, function () {
                if (shouldHover()) {
                    timeout = window.setTimeout(function () {
                        $this.removeClass('open');
                    }, settings.delay);
                }
            });

            $this.find('.dropdown-submenu').hover(function () {
                if (shouldHover()) {
                    window.clearTimeout(subTimeout);
                }
                $(this).children('.dropdown-menu').show();
            }, function () {
                var $submenu = $(this).children('.dropdown-menu');
                if (shouldHover()) {
                    subTimeout = window.setTimeout(function () {
                        $submenu.hide();
                    }, settings.delay);
                } else {
                    // emulate Twitter Bootstrap's default behavior
                    $submenu.hide();
                }
            });
        });
    };

    // helper function to see if we should hover
    var shouldHover = function () {
        return !!$('#cwspear-is-awesome').height();
    };
    $(document).ready(function () {
        // apply dropdownHover to all elements with the data-hover="dropdown" attribute
        $('[data-hover="dropdown"]').dropdownHover();

        // pure win here: we create these spans so we can test if we have the responsive css loaded
        // this is my attempt to hopefully make sure the IDs are unique
        $('<div class="nav-collapse collapse" style="visibility:hidden;position:fixed" id="cwspear-is-awesome">.</div>').appendTo('body');
    });

    // for the submenu to close on delay, we need to override Bootstrap's CSS in this case
    var css = '.dropdown-submenu:hover>.dropdown-menu{display:none}';
    var style = document.createElement('style');
    style.type = 'text/css';
    if (style.styleSheet) {
        style.styleSheet.cssText = css;
    } else {
        style.appendChild(document.createTextNode(css));
    }
    $('head')[0].appendChild(style);
})(jQuery, this);
