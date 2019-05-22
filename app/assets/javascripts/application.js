//= require jquery
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

function showShareIcons(title) {
  $("#shareIconsCount").jsSocials({
    shareIn: "popup",
    url: window.location.href,
    text: title,
    showCount: false,
    showLabel: false,
    shares: [
      "twitter",
      "facebook",
      "pinterest",
      "whatsapp",
      "messenger"
    ]
  });
}

$(document).on('click', '[data-toggle="lightbox"]', function(event) {
  event.preventDefault();
  $(this).ekkoLightbox();
});

$('#exampleModal').on('show.bs.modal', function (event) {
  var button = $(event.relatedTarget) // Button that triggered the modal
  var recipient = button.data('whatever') // Extract info from data-* attributes
  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
  var modal = $(this)
  modal.find('.modal-title').text('New message to ' + recipient)
  modal.find('.modal-body input').val(recipient)
})

$('#search').keyup(function(event){
  if (event.keyCode == 13) {
    event.preventDefault();
  }
});

// Sticky navbar
// =========================
$(document).ready(function () {
  // Custom function which toggles between sticky class (is-sticky)
  var stickyToggle = function (sticky, stickyWrapper, scrollElement) {
      var stickyHeight = sticky.outerHeight();
      var stickyTop = stickyWrapper.offset().top;
      if (scrollElement.scrollTop() >= stickyTop) {
          stickyWrapper.height(stickyHeight);
          sticky.addClass("is-sticky");
      }
      else {
          sticky.removeClass("is-sticky");
          stickyWrapper.height('auto');
      }
  };

  // Find all data-toggle="sticky-onscroll" elements
  $('[data-toggle="sticky-onscroll"]').each(function () {
      var sticky = $(this);
      var stickyWrapper = $('<div>').addClass('sticky-wrapper'); // insert hidden element to maintain actual top offset on page
      sticky.before(stickyWrapper);
      sticky.addClass('sticky');

      // Scroll & resize events
      $(window).on('scroll.sticky-onscroll resize.sticky-onscroll', function () {
          stickyToggle(sticky, stickyWrapper, $(this));
      });

      // On page load
      stickyToggle(sticky, stickyWrapper, $(window));
  });

  // Crop photo
  var output = document.getElementById('preview');

  $('#upload-file').on('change', function(event) {
    output.src = URL.createObjectURL(event.target.files[0]);

    output.addEventListener('crop', function(event) {
      console.log('crop', event.detail);
      $('#photo_crop_x').val(event.detail.x.toFixed());
      $('#photo_crop_y').val(event.detail.y.toFixed());
      $('#photo_crop_width').val(event.detail.width.toFixed());
      $('#photo_crop_height').val(event.detail.height.toFixed());
    });

    var cropper = new Cropper(output, {
      viewMode: 2,
      initialAspectRatio: 1,
      aspectRatio: 1,
      zoomable: false,
      minCropBoxHeight: 500,
      minCropBoxWidth: 500
    });
  });

  $('#upload-cover').on('change', function(event) {
    output.src = URL.createObjectURL(event.target.files[0]);

    output.addEventListener('crop', function(event) {
      $('#post_crop_x').val(event.detail.x.toFixed());
      $('#post_crop_y').val(event.detail.y.toFixed());
      $('#post_crop_width').val(event.detail.width.toFixed());
      $('#post_crop_height').val(event.detail.height.toFixed());
    });

    var cropper = new Cropper(output, {
      viewMode: 2,
      initialAspectRatio: 1,
      aspectRatio: 1,
      zoomable: false,
      minCropBoxHeight: 500,
      minCropBoxWidth: 500
    });
  });
});
