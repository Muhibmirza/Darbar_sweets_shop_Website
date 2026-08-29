(() => {
  const logoutLink = document.querySelector('.logout');
  if (!logoutLink) return;
  const modal = document.createElement('div');
  modal.className = 'admin-modal';
  modal.setAttribute('role', 'dialog');
  modal.setAttribute('aria-modal', 'true');
  modal.innerHTML = `<div class="admin-modal-card"><span class="modal-icon" aria-hidden="true">&#8594;</span><h2>Sign out of admin?</h2><p>Your current admin session will be closed safely.</p><div><button type="button" class="btn btn-outline modal-cancel">Stay signed in</button><a class="btn" href="?logout=1">Yes, sign out</a></div></div>`;
  document.body.appendChild(modal);
  const close = () => modal.classList.remove('open');
  logoutLink.addEventListener('click', event => { event.preventDefault(); modal.classList.add('open'); modal.querySelector('.modal-cancel').focus(); });
  modal.querySelector('.modal-cancel').addEventListener('click', close);
  modal.addEventListener('click', event => { if (event.target === modal) close(); });
  document.addEventListener('keydown', event => { if (event.key === 'Escape') close(); });
})();

// Premium admin enhancements are loaded below.
['premium-admin.css'].forEach(h=>{const l=document.createElement('link');l.rel='stylesheet';l.href=h+'?v=20260829';document.head.appendChild(l)});
['charts.js','footer-controls.js'].forEach(s=>{const x=document.createElement('script');x.src=s+'?v=20260829c';document.body.appendChild(x)});
