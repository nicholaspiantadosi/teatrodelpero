# Teatro del Pero — sito web

Sito statico (HTML + CSS + un po' di JavaScript). **Nessun server, nessun database, nessun programma da installare.** Si apre direttamente nel browser e si pubblica caricando i file.

---

## 1. Come vedere il sito sul tuo computer

Basta fare **doppio clic su `index.html`**: si apre nel browser. Tutto qui.

> Suggerimento: se vuoi vederlo "come online" (consigliato ma non obbligatorio), apri un terminale in questa cartella e lancia:
> ```bash
> python3 -m http.server 8000
> ```
> poi visita `http://localhost:8000` nel browser. Si ferma con `Ctrl+C`.

---

## 2. Struttura dei file

```
site/
├─ index.html          → Home
├─ chi-siamo.html      → Chi siamo (storia, componenti, premi)
├─ stagione.html       → Stagione teatrale (cartellone + sinossi)
├─ produzioni.html     → Produzioni (in scena + archivio)
├─ laboratori.html     → Laboratori (corsi)
├─ contatti.html       → Contatti (recapiti + location)
├─ README.md           → questo file
└─ assets/
   ├─ css/style.css    → TUTTA la grafica (colori, font, layout)
   ├─ js/menu.js       → menu a tendina per smartphone
   └─ img/             → immagini (metti qui le tue foto)
```

---

## 3. Come modificare i testi

Apri il file `.html` della pagina che vuoi cambiare con un **editor di testo**
(va benissimo il Blocco note / TextEdit, o meglio ancora un editor come VS Code).

Tutti i punti da personalizzare sono segnati con un commento ben visibile:

```html
<!-- SEGNAPOSTO: ... descrizione di cosa mettere ... -->
```

Cerca la parola **SEGNAPOSTO** nel file e sostituisci il testo che segue.
Non toccare le "etichette" fra `< >` (i tag): cambia solo il testo scritto in mezzo.

Esempio — cambiare la frase della home (`index.html`):
```html
<!-- prima -->
<p class="hero-lead">Mettiamo in scena il presente. ...</p>
<!-- dopo -->
<p class="hero-lead">La tua frase di presentazione.</p>
```

---

## 4. Come aggiungere le foto

1. Copia le immagini dentro la cartella `assets/img/` (es. `compagnia.jpg`, `tempesta.jpg`).
2. Nei file HTML, i riquadri foto sono dei blocchi come questo:

   ```html
   <div class="ph" data-label="Foto di scena"></div>
   ```

3. Per inserire una foto reale, trasformalo così (aggiungi la classe `has-img` e l'immagine):

   ```html
   <div class="ph has-img">
     <img src="assets/img/compagnia.jpg" alt="La compagnia sul palco">
   </div>
   ```

   La foto riempirà automaticamente il riquadro con le giuste proporzioni.
   Ricordati sempre il testo `alt="..."`: descrive l'immagine ed è importante per
   l'accessibilità e per Google.

**Formati consigliati:** `.jpg` per le foto, immagini larghe ~1600px, salvate
"per il web" per non appesantire il sito.

---

## 5. Aggiungere o togliere spettacoli, componenti, premi, laboratori

Sono tutti blocchi ripetibili. Per **aggiungere** un elemento, copia un blocco
esistente e incollalo subito dopo; per **toglierlo**, cancella il blocco intero.

- **Spettacolo** (`produzioni.html`): copia un blocco `<article class="tile prod-card"> ... </article>`.
  L'etichetta in fondo è `<span class="pill">In scena</span>` (giallo) oppure
  `<span class="pill archivio">Archivio</span>` (grigio).
- **Componente** (`chi-siamo.html`): copia un blocco `<div class="member"> ... </div>`.
- **Premio** (`chi-siamo.html`): copia un blocco `<div class="award"> ... </div>`.
- **Laboratorio** (`laboratori.html`): copia un blocco `<div class="lab"> ... </div>`.
- **Spettacolo di stagione** (`stagione.html`): copia un blocco `<article class="show"> ... </article>`.
  Ogni blocco ha una colonna data (`.show-date` con giorno, mese e orario) e un corpo
  (`.show-body` con titolo, autore/regia, compagnia e sinossi). Le informazioni pratiche
  della stagione (luogo, telefono, organizzazione) stanno in cima alla pagina nel blocco
  `.season-info`.

---

## 6. Cambiare i colori

Apri `assets/css/style.css`: in cima trovi la sezione `:root` con i colori.
Cambia un valore e cambia in tutto il sito. I principali:

```css
--bg:#141210;        /* sfondo scuro */
--mustard:#e8a62b;   /* giallo senape (accento principale) */
--terra:#d9542b;     /* terracotta (accento secondario) */
--off:#f2ebdd;       /* colore del testo */
```

---

## 7. Come pubblicarlo online (gratis)

Essendo un sito statico puoi caricarlo quasi ovunque. Le opzioni più semplici e
gratuite (nessuna conoscenza tecnica avanzata richiesta):

- **Netlify Drop** — vai su https://app.netlify.com/drop e **trascina la cartella `site/`**
  nella pagina. In pochi secondi il sito è online con un indirizzo provvisorio.
  È il modo più rapido in assoluto.
- **Cloudflare Pages** / **GitHub Pages** — gratuiti, adatti se vuoi collegare un
  dominio tuo e aggiornare con un po' più di metodo.
- **Hosting tradizionale via FTP** — se hai già un hosting, carica i file dentro la
  cartella pubblica (di solito `public_html`). Funziona perché sono file statici.

### Dominio

Per avere `www.teatrodelpero.it` serve registrare il dominio (circa **10–15 €/anno**)
presso un registrar (es. Register.it, Aruba, Cloudflare, Namecheap) e collegarlo al
servizio di hosting scelto. È l'unica spesa ricorrente del progetto.

---

## 8. Checklist prima di pubblicare

- [ ] Sostituito tutti i testi **SEGNAPOSTO**
- [ ] Inserite le foto reali in `assets/img/`
- [ ] Aggiornati email, telefono, indirizzo e link social (in **ogni** pagina: stanno nel footer)
- [ ] Controllato il sito su smartphone (o restringendo la finestra del browser)
- [ ] Verificati gli spettacoli: quali "In scena" e quali in "Archivio"

> Nota: email, telefono e link social sono ripetuti nel footer di tutte le pagine.
> Quando li aggiorni, ricordati di farlo in tutti i file `.html` (sono 6).
