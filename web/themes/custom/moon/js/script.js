/**
 * @file
 * Placeholder file for custom sub-theme behaviors.
 *
 */
(function ($, Drupal) {

  /**
   * Use this behavior as a template for custom Javascript.
   */
  Drupal.behaviors.exampleBehavior = {
    attach: function (context, settings) {
      //alert("I'm alive!");
      console.log(window.jQuery.fn.jquery);

    }
  };








// IPHONE
// MOBILE VERSION NAVI EIN AUS
var openmenu = false;
$(".navi-on").click(function() {
  $(".mobile_navigation").slideToggle("slow");
});







})(jQuery, Drupal);
