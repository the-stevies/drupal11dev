/**
 * @file
 * Placeholder file for custom sub-theme behaviors.
 *
 */
(function($, Drupal) {

  /**
   * Use this behavior as a template for custom Javascript.
   */
  Drupal.behaviors.exampleBehavior = {
    attach: function(context, settings) {
      //alert("I'm alive!");
      console.log(window.jQuery.fn.jquery);
      console.log('JS loaded');


      let audioCtx = null;
      let soundOn = false;

      // Ein einzelner dumpfer Schlag: Sinuston, der schnell in der Tonhöhe fällt und ausklingt
      function thump(time, freq, volume) {
        const osc  = audioCtx.createOscillator();
        const gain = audioCtx.createGain();

        osc.type = 'sine';
        osc.frequency.setValueAtTime(freq, time);
        osc.frequency.exponentialRampToValueAtTime(freq * 0.5, time + 0.15);

        gain.gain.setValueAtTime(0.0001, time);
        gain.gain.exponentialRampToValueAtTime(volume, time + 0.01); // schneller Anschlag
        gain.gain.exponentialRampToValueAtTime(0.0001, time + 0.2);  // Ausklingen

        osc.connect(gain).connect(audioCtx.destination);
        osc.start(time);
        osc.stop(time + 0.25);
      }

      // Lub-Dub: zweiter Schlag 0,3 s nach dem ersten, passend zu den Tweens
      function playBeat() {
        if (!soundOn || !audioCtx) return;
        const now = audioCtx.currentTime;
        thump(now,       80, 0.9); // Lub (kräftiger)
        thump(now + 0.3, 65, 0.6); // Dub (leiser, etwas tiefer)
      }

      const heartbeat = gsap.timeline({ repeat: -1, repeatDelay: 0.6, paused: true });

      heartbeat
        .to('.pattern-one img', { scale: 1.12, duration: 0.15, ease: 'power2.out', onStart: playBeat })
        .to('.pattern-one img', { scale: 1.0,  duration: 0.15, ease: 'power2.in' })
        .to('.pattern-one img', { scale: 1.08, duration: 0.15, ease: 'power2.out' })
        .to('.pattern-one img', { scale: 1.0,  duration: 0.3,  ease: 'power2.in' });

      const tl = gsap.timeline({ onComplete: () => heartbeat.play() });

      tl.from('.pattern-one h1', { x: 200, duration: 1 })
        .from('.pattern-one p',  { opacity: 0, y: 30, duration: 0.8 })
        .from('.pattern-one img', { scale: 0.8, opacity: 0, duration: 0.6 });

      $('.pattern-one').on('click', function () {
        if (tl.isActive()) return;

        // Erster Klick: Ton aktivieren, Herzschlag läuft weiter
        if (!audioCtx) {
          audioCtx = new (window.AudioContext || window.webkitAudioContext)();
          audioCtx.resume();
          soundOn = true;
          return;
        }

        // Weitere Klicks: Herzschlag samt Ton an/aus
        if (heartbeat.paused()) {
          soundOn = true;
          heartbeat.play();
        } else {
          soundOn = false;
          heartbeat.pause(0);
        }
      });


      
    }
  };








  // IPHONE
  // MOBILE VERSION NAVI EIN AUS
  var openmenu = false;
  $(".navi-on").click(function() {
    $(".mobile_navigation").slideToggle("slow");
  });







})(jQuery, Drupal);
