// Opens each demand's full text in a native <dialog> (focus trap, Esc to close
// and backdrop all come built in).
document.querySelectorAll('[data-demand-open]').forEach(function (btn) {
  var dlg = document.getElementById(btn.getAttribute('data-demand-open'));
  if (!dlg || typeof dlg.showModal !== 'function') return;
  btn.addEventListener('click', function () { dlg.showModal(); });
});

document.querySelectorAll('dialog.demand-dialog').forEach(function (dlg) {
  dlg.addEventListener('click', function (e) {
    // Click on the dim backdrop (the dialog element itself) or the × button.
    if (e.target === dlg || e.target.closest('[data-demand-close]')) dlg.close();
  });
});