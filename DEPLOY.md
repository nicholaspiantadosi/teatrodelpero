# Stato tecnico & Deploy — Teatro del Pero

Documento di riferimento sullo stato tecnico del progetto e sulla procedura di
pubblicazione online. Aggiornare quando cambia qualcosa di rilevante.

---

## 1. Cos'è il progetto

Sito **statico** (HTML + CSS + un filo di JavaScript). Nessun server applicativo,
nessun database, nessun processo di build: i file si aprono direttamente nel browser
e si pubblicano caricandoli così come sono.

- **Radice del progetto:** `/home/npiantadosi/git/personale/teatro`
- **Cartella pubblicabile (quella che va online):** `site/`
- **Pagine:** `index.html`, `chi-siamo.html`, `stagione.html`, `produzioni.html`,
  `laboratori.html`, `contatti.html`
- **Asset:** `site/assets/` (`css/`, `js/`, `img/`)
- **Config hosting:** `netlify.toml` nella **radice** del progetto (`publish = "site"`).

---

## 2. Hosting attuale

- **Provider:** Netlify
- **Metodo usato finora:** pubblicazione manuale via **Netlify Drop**
  (https://app.netlify.com/drop) — trascinando la cartella `site/`.
- **Progetto Netlify:** https://app.netlify.com/projects/magnificent-mandazi-6d5f44/overview
- **Slug del sito:** `magnificent-mandazi-6d5f44`
- **URL pubblico (default Netlify):** `https://magnificent-mandazi-6d5f44.netlify.app`
  (confermato da un deploy di anteprima andato a buon fine il 2026-11-04).
- **Account ID Netlify:** `6ae49e68be522cd20e2b808b`
- **Dominio personalizzato:** non ancora configurato.

---

## 3. Strumenti disponibili sulla macchina

Verificati il 2026-11-04:

| Strumento    | Stato                          |
|--------------|--------------------------------|
| node         | v25.2.1 (via nvm)              |
| npx          | 11.6.2                         |
| Netlify CLI  | non installato (si usa `npx netlify-cli`) |
| curl         | presente                       |
| zip          | presente                       |
| git          | repo inizializzato, remote su GitHub (vedi §4) |

---

## 4. Deploy automatico — flusso principale (CD da GitHub)

Il metodo **consigliato e principale** è il *continuous deployment* di Netlify
collegato al repository Git: a ogni `git push` sul branch `main`, Netlify ricostruisce
e pubblica da solo. Le pull request generano automaticamente una **Deploy Preview**.

### Repository

- **Hosting codice:** GitHub (account personale `nicholaspiantadosi`), separato dal
  GitLab di lavoro `git.myargo.it`.
- **Remote:** `git@github.com:nicholaspiantadosi/teatrodelpero.git` (SSH).
- **Branch pubblicato:** `main`.
- **Identità commit (solo questo repo):** `Nicholas <nicholaspiantadosi@gmail.com>`
  impostata con `git config --local` — la config globale non è toccata, così i commit
  personali non si mescolano con quelli di lavoro.

### Autenticazione SSH verso GitHub (su questa macchina)

La chiave usata è `~/.ssh/id_ed25519_github`, dichiarata esplicitamente in
`~/.ssh/config`:

```
Host github.com
	HostName github.com
	User git
	IdentityFile ~/.ssh/id_ed25519_github
	IdentitiesOnly yes
```

> Nota: il `~/.ssh/config` ha un blocco `Host *` con `IdentitiesOnly=yes`; senza il
> blocco `Host github.com` qui sopra, SSH non presenterebbe alcuna chiave e GitHub
> risponderebbe `Permission denied (publickey)`. La chiave **pubblica** corrispondente
> è caricata su GitHub → *Settings → SSH and GPG keys*.

Test rapido dell'autenticazione:

```bash
ssh -T git@github.com   # atteso: "Hi nicholaspiantadosi! ..."
```

### Pubblicare (flusso normale)

```bash
git add -A
git commit -m "descrizione modifica"
git push            # main è già in tracking con origin/main → parte il deploy
```

### Collegamento repo ↔ sito Netlify (da fare UNA volta)

Netlify → progetto `magnificent-mandazi-6d5f44` →
*Site configuration → Build & deploy → Continuous deployment → Link repository* →
GitHub → `nicholaspiantadosi/teatrodelpero`. Branch: `main`. Build command: **vuoto**,
Publish directory: **`site`** (letti comunque da `netlify.toml`).

---

## 5. Deploy manuale — fallback (script CLI)

Quando il CD non è disponibile (o serve un'anteprima al volo), resta lo script
**`scripts/deploy.sh`** che pubblica la cartella `site/` tramite la CLI ufficiale
(`npx netlify-cli deploy`).

### Prerequisiti (da impostare UNA volta sola)

Lo script ha bisogno di due valori che **non** sono salvati nel repo per sicurezza:

1. **Site ID** del progetto Netlify
   - Dove trovarlo: dashboard del sito →
     *Site configuration → General → Site information → Site ID* (è un UUID).
   - Lo slug `magnificent-mandazi-6d5f44` NON è il Site ID: serve l'UUID.

2. **Personal Access Token** Netlify
   - Dove crearlo: https://app.netlify.com/user/applications#personal-access-tokens
     → *New access token*.
   - **Credenziali già impostate** in `scripts/.deploy.env` (il 2026-11-04).
   - ⚠️ **Scadenza token: 2027-02-02** (90 giorni dal 2026-11-04). Dopo questa data
     il deploy fallirà con errore di autenticazione: rigenerare il token e riscriverlo
     in `scripts/.deploy.env`.

Questi due valori vanno messi in un file locale **non versionato**,
`scripts/.deploy.env` (già previsto in `.gitignore`):

```bash
NETLIFY_SITE_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
NETLIFY_AUTH_TOKEN="il-tuo-token"
```

In alternativa si possono esportare come variabili d'ambiente prima di lanciare lo script.

### Come pubblicare

```bash
# deploy di PRODUZIONE (va sull'URL pubblico del sito)
./scripts/deploy.sh

# deploy di ANTEPRIMA (genera un URL temporaneo, non tocca la produzione)
./scripts/deploy.sh --preview
```

Lo script:
1. carica le credenziali da `scripts/.deploy.env` (se presente);
2. controlla che ci sia la cartella `site/` con dentro `index.html`;
3. lancia `npx netlify-cli deploy` con `--dir=site` e il Site ID;
4. stampa l'URL risultante.

> In questa sessione l'agente può lanciare `./scripts/deploy.sh` quando glielo chiedi,
> a patto che `scripts/.deploy.env` sia già compilato.

---

## 6. Da fare / decisioni aperte

- [x] Compilare `scripts/.deploy.env` con Site ID e token (fatto 2026-11-04;
      token in scadenza il **2027-02-02**).
- [x] Confermare l'URL pubblico definitivo nella dashboard Netlify.
      → `https://magnificent-mandazi-6d5f44.netlify.app` (confermato 2026-11-04).
- [x] Riempire i contenuti reali del sito dal PDF
      `Il_Teatro_del_Pero_testi_sito_web.pdf` (fatto 2026-11-06, deploy in produzione
      `deployId 6aed94eb4c9a3f3146601610`). Vedi §7.
- [x] Inizializzare un repo git e collegarlo a GitHub per il deploy continuo
      (fatto 2026-11-06, remote `nicholaspiantadosi/teatrodelpero`). Vedi §4.
- [ ] Completare su Netlify il *Link repository* per attivare il CD (vedi §4): finché non
      è fatto, la pubblicazione resta manuale via `scripts/deploy.sh`.
- [ ] Fornire i recapiti reali mancanti: **email** (resta segnaposto
      `info@teatrodelpero.it`) e **link Instagram** (resta `href="#"`). Presenti invece
      il telefono reale `392 4745053` e la pagina Facebook.
- [ ] Valutare un dominio personalizzato (es. `www.teatrodelpero.it`, ~10–15 €/anno).

---

## 7. Contenuti pubblicati

### 7.1 Testi dal PDF (2026-11-06)

Fonte dei testi: `Il_Teatro_del_Pero_testi_sito_web.pdf` (estratto con `pdftotext -layout`).
Riempiti i blocchi `SEGNAPOSTO` nelle pagine con i contenuti reali:

- **index.html** — frase di presentazione ("Dal 2004, la passione per il teatro diventa
  incontro…"), badge → stagione, ticker con parole chiave reali, sezione "Domenica Rido —
  in programma" con i primi 3 spettacoli della stagione, tile sezioni aggiornate.
- **chi-siamo.html** — storia reale (associazione fondata a marzo 2004), direttivo con
  **Salvatore Purromuto** (presidente dalla fondazione), sezioni "La nostra compagnia" e
  "Domenica Rido" al posto della sezione premi (inventata, rimossa).
- **produzioni.html** — repertorio reale: **17 spettacoli** con autori
  (Martoglio, Capuana, De Filippo, Scarpetta, Molière, ecc.). "In scena ora" rimanda alla
  stagione.
- **contatti.html** — "Ci vediamo a teatro", telefono reale `392 4745053`, sede
  Teatro Naselli (Comiso). Rimossi indirizzo e location inventati.
- **footer (tutte le pagine)** — descrizione breve e telefono reali.

> `stagione.html` era già compilata con il cartellone reale "Domenica Rido" 2026/2027:
> lasciata invariata, allineati solo footer e menu.

### 7.2 Sezione Laboratorio (2026-11-06)

Fonti: `laboratori.txt` (testo) e `laboratorio.jpeg` (locandina, copiata in
`site/assets/img/laboratorio.jpeg`).

- **laboratori.html** — ora è la pagina del laboratorio **“Il Gioco del Teatro”** a cura di
  **Aldo Rapè** al Teatro Naselli di Comiso: percorso di 8 mesi, programma (respirazione,
  dizione/voce, movimento, improvvisazione, recitazione, spazio/tempo scenico), quote
  (adulti 60 €/mese, minori 35 €/mese, iscrizione annuale 20 €, sconto 25% stesso nucleo
  familiare), spettacolo finale e coinvolgimento negli eventi PRIMAQUINTA.
- **Immagine** — la locandina dell'Open Day (evento passato, venerdì 11 settembre, Spazio
  Naselli) è usata come foto illustrativa della pagina, non come annuncio di una data futura.
- **Menu** — la voce di navigazione è stata rinominata da "Domenica Rido" a **"Laboratorio"**
  su tutte le pagine (header + footer) e la tile "03" della home ora rimanda a "Il Gioco del
  Teatro". La rassegna Domenica Rido resta coperta da `stagione.html` e dalla sezione in
  `chi-siamo.html`.
