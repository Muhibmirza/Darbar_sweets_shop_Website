(() => {
  const fontStyles=document.createElement('link');fontStyles.rel='stylesheet';fontStyles.href='https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@600;700&family=Manrope:wght@400;500;600;700;800&display=swap';document.head.appendChild(fontStyles);
  const premiumStyles=document.createElement('link');premiumStyles.rel='stylesheet';premiumStyles.href=(window.DARBAR?.base||'')+'assets/css/premium.css';document.head.appendChild(premiumStyles);
  const atelierStyles=document.createElement('link');atelierStyles.rel='stylesheet';atelierStyles.href=(window.DARBAR?.base||'')+'assets/css/atelier.css?v=20260829';document.head.appendChild(atelierStyles);
  const $=(s,c=document)=>c.querySelector(s), $$=(s,c=document)=>[...c.querySelectorAll(s)];
  let cart=Array.isArray(window.DARBAR.cart)?window.DARBAR.cart:Object.values(window.DARBAR.cart||{});
  const money=n=>'Rs. '+Number(n).toLocaleString('en-PK');
  function renderCart(){
    const html=cart.length?cart.map(i=>`<div class="cart-line"><img src="${i.image}" alt=""><div><h3>${i.name}</h3><small>${money(i.price)}</small><div class="qty"><button data-cart-action="down" data-id="${i.id}">−</button><b>${i.qty}</b><button data-cart-action="up" data-id="${i.id}">+</button></div></div><button class="remove-line" data-cart-action="remove" data-id="${i.id}">×</button></div>`).join(''):'<div class="empty">Your bag is waiting for something sweet.</div>';
    $$('.cart-lines').forEach(x=>x.innerHTML=html); const sub=cart.reduce((a,i)=>a+i.price*i.qty,0);
    $$('.cart-subtotal').forEach(x=>x.textContent=money(sub)); $$('.cart-badge').forEach(x=>x.textContent=cart.reduce((a,i)=>a+i.qty,0));
    const full=$('#fullCart'); if(full) full.innerHTML=html+`<div class="order-summary"><h3>Order summary</h3><p>Subtotal <strong>${money(sub)}</strong></p><p>Delivery <strong>${sub>=2000?'Complimentary':'Calculated at checkout'}</strong></p><a class="btn btn-block" href="?page=checkout">Proceed to checkout</a></div>`;
    const checkout=$('#checkoutItems');if(checkout)checkout.innerHTML=cart.map(i=>`<div class="cart-checkout-line"><img src="${i.image}"><span>${i.name}<small> × ${i.qty}</small></span><strong>${money(i.price*i.qty)}</strong></div>`).join('');
  }
  const drawer=$('.cart-drawer'),overlay=$('.cart-overlay');
  function openCart(){drawer?.classList.add('open');overlay?.classList.add('open');drawer?.setAttribute('aria-hidden','false')}
  function closeCart(){drawer?.classList.remove('open');overlay?.classList.remove('open');drawer?.setAttribute('aria-hidden','true')}
  $('.cart-open')?.addEventListener('click',openCart);$('.cart-close')?.addEventListener('click',closeCart);overlay?.addEventListener('click',closeCart);
  const searchPanel=$('.search-panel');function toggleSearch(open){searchPanel?.classList.toggle('open',open);searchPanel?.setAttribute('aria-hidden',open?'false':'true');if(open)setTimeout(()=>$('#globalSearch')?.focus(),150)}
  $('.search-btn')?.addEventListener('click',()=>toggleSearch(true));$('.search-close')?.addEventListener('click',()=>toggleSearch(false));document.addEventListener('keydown',e=>{if(e.key==='Escape')toggleSearch(false)});
  async function update(payload){
    const r=await fetch(`${DARBAR.base}api/cart.php`,{method:'POST',headers:{'Content-Type':'application/json','X-CSRF-Token':DARBAR.csrf},body:JSON.stringify(payload)});
    if(!r.ok)throw new Error('Cart update failed');const d=await r.json();cart=d.cart;renderCart();$$('.cart-badge').forEach(x=>{x.classList.remove('pop');void x.offsetWidth;x.classList.add('pop')});return d;
  }
  document.addEventListener('click',async e=>{
    const gallery=e.target.closest('[data-gallery]');if(gallery){const main=$('#detailMain');if(main)main.src=gallery.dataset.gallery}
    const add=e.target.closest('.add-cart'); if(add){const old=add.textContent,qty=add.classList.contains('detail-add')?Math.max(1,+($('#detailQty')?.value||1)):1;add.disabled=true;add.textContent='…';try{await update({id:add.dataset.id,name:add.dataset.name,price:add.dataset.price,image:add.dataset.image,qty});openCart();showToast('Added to your Darbar bag')}finally{add.disabled=false;add.textContent=old}}
    const a=e.target.closest('[data-cart-action]');if(a){const i=cart.find(x=>String(x.id)===a.dataset.id);if(!i)return;const type=a.dataset.cartAction;if(type==='remove')await update({action:'remove',id:i.id});else await update({action:'set',id:i.id,qty:type==='up'?i.qty+1:Math.max(1,i.qty-1)})}
  });
  function showToast(t){const el=$('.toast');el.textContent=t;el.classList.add('show');setTimeout(()=>el.classList.remove('show'),1800)}
  const search=$('#shopSearch'),category=$('#categoryFilter'),sort=$('#sortProducts');
  function filter(){let cards=$$('.shop-products .product-card');cards.forEach(c=>c.hidden=!(c.dataset.name.includes((search?.value||'').toLowerCase())&&(!category?.value||c.dataset.category===category.value)));if(sort?.value!=='featured'){cards.sort((a,b)=>(+a.dataset.price- +b.dataset.price)*(sort.value==='high'?-1:1)).forEach(c=>c.parentNode.appendChild(c))}}
  [search,category,sort].forEach(x=>x?.addEventListener('input',filter));renderCart();
  fetch((window.DARBAR?.base||'')+'api/site-settings.php').then(r=>r.json()).then(s=>{
    const c=$$('.footer-grid>div');if(c[0]?.querySelector('p'))c[0].querySelector('p').textContent=s.footer_about;
    if(c[3]){const p=c[3].querySelectorAll('p');if(p[0])p[0].textContent=s.footer_location;if(p[1])p[1].textContent=s.footer_hours;if(p[2])p[2].textContent=s.footer_phone;const links=[['Facebook',s.footer_facebook],['Instagram',s.footer_instagram],['WhatsApp',s.footer_whatsapp]].filter(x=>/^https?:\/\//i.test(x[1]||''));if(links.length){const d=document.createElement('div');d.className='footer-socials';links.forEach(([l,u])=>{const a=document.createElement('a');a.textContent=l;a.href=u;a.target='_blank';a.rel='noopener';d.appendChild(a)});c[3].appendChild(d)}}
    const b=$('.footer-bottom'),t=b?[...b.childNodes].find(n=>n.nodeType===3&&n.textContent.trim()):null;if(t)t.textContent='© '+new Date().getFullYear()+' '+s.footer_copyright+' ';
    const m={visa:'payment_visa',mastercard:'payment_mastercard',jazzcash:'payment_jazzcash',easypaisa:'payment_easypaisa'};$$('.payment-logos img').forEach(i=>{const k=Object.keys(m).find(x=>(i.alt+' '+i.src).toLowerCase().includes(x));if(k)i.hidden=s[m[k]]!=='1'});
  }).catch(()=>{});
  const reducedMotion=matchMedia('(prefers-reduced-motion: reduce)').matches;
  const header=$('.site-header'),navToggle=$('.nav-toggle');
  requestAnimationFrame(()=>document.body.classList.add('page-ready'));
  addEventListener('scroll',()=>header?.classList.toggle('scrolled',scrollY>18),{passive:true});
  navToggle?.addEventListener('click',()=>{const open=document.body.classList.toggle('nav-open');navToggle.setAttribute('aria-expanded',String(open))});
  $$('.nav nav a').forEach(link=>link.addEventListener('click',()=>document.body.classList.remove('nav-open')));
  const revealObserver='IntersectionObserver' in window?new IntersectionObserver(entries=>entries.forEach(entry=>{if(entry.isIntersecting){entry.target.classList.add('in-view');revealObserver.unobserve(entry.target)}}),{threshold:.12,rootMargin:'0px 0px -40px'}):null;
  $$('.reveal').forEach((el,i)=>{el.style.setProperty('--reveal-delay',`${(i%4)*65}ms`);if(revealObserver)revealObserver.observe(el);else el.classList.add('in-view')});
  const slides=$$('.banner-slide'),dots=$$('.banner-dots span');let bannerIndex=0,bannerTimer;
  function showBanner(index,initial=false){
    if(!slides.length)return;
    const nextIndex=(index+slides.length)%slides.length,current=slides[bannerIndex],next=slides[nextIndex];
    if(initial){slides.forEach((slide,i)=>{slide.classList.toggle('active',i===nextIndex);slide.setAttribute('aria-hidden',String(i!==nextIndex))});bannerIndex=nextIndex;return}
    if(nextIndex===bannerIndex)return;
    current.classList.remove('active');current.classList.add('leaving');current.setAttribute('aria-hidden','true');
    next.classList.add('active');next.setAttribute('aria-hidden','false');
    dots.forEach((dot,i)=>dot.classList.toggle('active',i===nextIndex));bannerIndex=nextIndex;
    setTimeout(()=>{current.classList.add('no-transition');current.classList.remove('leaving');requestAnimationFrame(()=>requestAnimationFrame(()=>current.classList.remove('no-transition')))},900);
  }
  function startBanners(){if(slides.length>1&&!reducedMotion){clearInterval(bannerTimer);bannerTimer=setInterval(()=>showBanner(bannerIndex+1),2000)}}
  showBanner(0,true);dots.forEach((dot,i)=>dot.classList.toggle('active',i===0));startBanners();
  if(window.gsap&&!reducedMotion){
    gsap.registerPlugin(ScrollTrigger);
    const section=$('.sweet-break');if(section){const tl=gsap.timeline({scrollTrigger:{trigger:section,start:'top top',end:'bottom bottom',scrub:1,pin:'.break-stage'}});
      tl.to('.intact',{opacity:0,scale:.94,duration:.18},.18).to('.sweet-half',{opacity:1,duration:.08},.2).to('.sweet-half.left',{x:'-26%',y:'9%',rotation:-12,ease:'back.out(1.4)',duration:.3},.22).to('.sweet-half.right',{x:'26%',y:'9%',rotation:12,ease:'back.out(1.4)',duration:.3},.22).to('.syrup-photo',{scaleY:1,opacity:1,duration:.3,ease:'power3.out'},.38).to('.break-copy',{opacity:1,y:0,duration:.25},.62).to('.sweet-composition',{scale:1.08,opacity:.3,duration:.3},.72);
      gsap.to('.syrup-photo',{filter:'brightness(1.2) saturate(1.15)',repeat:-1,yoyo:true,duration:1.2,ease:'sine.inOut'});
    }
    $$('.category-motion').forEach(section=>{const type=section.dataset.motion,tl=gsap.timeline({scrollTrigger:{trigger:section,start:'top top',end:'bottom bottom',scrub:1,pin:section.querySelector('.category-stage')}});tl.fromTo(section.querySelector('.cat-base'),{scale:.92},{scale:1.04,duration:.6,ease:'power2.out'}).to(section.querySelector('.cat-layer-a'),{x:type==='open'?'-18%':'-12%',y:type==='scoop'?'-22%':'6%',rotation:type==='scoop'?-18:-8,opacity:.9,duration:.5,ease:'back.out(1.4)'},.18).to(section.querySelector('.cat-layer-b'),{x:type==='open'?'18%':'12%',y:type==='garnish'?'-14%':'8%',rotation:type==='slice'?14:8,opacity:.75,duration:.5,ease:'back.out(1.4)'},.22).fromTo(section.querySelector('.category-copy'),{opacity:0,y:30},{opacity:1,y:0,duration:.35},.48)});
    $$('.product-card,.tilt-card,.quote-grid blockquote').forEach(card=>{
      card.addEventListener('pointermove',e=>{const r=card.getBoundingClientRect(),x=(e.clientX-r.left)/r.width-.5,y=(e.clientY-r.top)/r.height-.5;gsap.to(card,{rotationY:x*7,rotationX:-y*7,z:8,duration:.35,ease:'power2.out',transformPerspective:900})});
      card.addEventListener('pointerleave',()=>gsap.to(card,{rotationY:0,rotationX:0,z:0,duration:.55,ease:'elastic.out(1,.45)'}));
    });
    if($('.hero-art'))gsap.to('.hero-art img',{yPercent:8,scale:1.08,ease:'none',scrollTrigger:{trigger:'.hero',start:'top top',end:'bottom top',scrub:true}});
  }
})();
