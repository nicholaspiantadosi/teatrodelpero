/* Menu mobile: apre/chiude la navigazione con l'hamburger.
   Nessuna dipendenza esterna. */
(function () {
  var toggle = document.querySelector('.nav-toggle');
  var links = document.getElementById('nav-links');
  if (!toggle || !links) return;

  toggle.addEventListener('click', function () {
    var open = links.getAttribute('data-open') === 'true';
    links.setAttribute('data-open', String(!open));
    toggle.setAttribute('aria-expanded', String(!open));
  });

  // chiudi il menu quando si clicca una voce (mobile)
  links.addEventListener('click', function (e) {
    if (e.target.tagName === 'A') {
      links.setAttribute('data-open', 'false');
      toggle.setAttribute('aria-expanded', 'false');
    }
  });
})();
