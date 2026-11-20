// Open the FAQ answer a link points to (e.g. "Details" in How to Join links
// to #faq-cost). Without this the page scrolls to the question but leaves
// the answer closed. Works for direct visits to #faq-… URLs too.
(function () {
  function openTarget(id) {
    var el = id && document.getElementById(id);
    if (el && el.tagName === 'DETAILS') el.open = true;
  }

  // Clicking the same link twice doesn't fire hashchange, so handle clicks.
  document.addEventListener('click', function (e) {
    var a = e.target.closest && e.target.closest('a[href*="#faq-"]');
    if (a) openTarget(decodeURIComponent(a.hash.slice(1)));
  });

  window.addEventListener('hashchange', function () {
    openTarget(decodeURIComponent(location.hash.slice(1)));
  });

  openTarget(decodeURIComponent(location.hash.slice(1)));
})();
