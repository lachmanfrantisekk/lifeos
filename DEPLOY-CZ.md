# LifeOS — nasazení krok za krokem

## Předpoklady
Účet GitHub, účet Cloudflare, Node.js 22+, GitHub Desktop. **Důležité:** GitHub Pages hostuje veřejné statické soubory; osobní údaje zůstávají pouze v Cloudflare D1. Přihlášení přes Cloudflare Access je nutné nastavit před používáním.

## 1. GitHub
1. Rozbal ZIP a v GitHub Desktop zvol File → Add local repository; pokud projekt ještě není Git repository, zvol Create a repository here.
2. Publish repository → doporučujeme **Private**. GitHub Pages je dostupný dle plánu/repozitáře; při potížích použij veřejný repozitář bez tajných údajů.
3. Na GitHubu otevři Settings → Pages → Build and deployment → Source: **GitHub Actions**.
4. V Settings → Secrets and variables → Actions → Variables přidej `VITE_API_URL` s úplnou HTTPS adresou Workeru (bez koncového lomítka).
5. Po nastavení API znovu spusť Actions → Deploy LifeOS → Run workflow. Výsledná adresa bude `https://UZIVATEL.github.io/NAZEV-REPO/`.

## 2. Cloudflare D1
1. Otevři Cloudflare Dashboard → Workers & Pages → D1 → Create database. Název `lifeos`.
2. Zkopíruj database ID.
3. V `worker/wrangler.jsonc` nahraď `REPLACE_WITH_D1_DATABASE_ID`.
4. V terminálu v kořeni projektu spusť:

```bash
npm install
cd worker
npx wrangler login
npx wrangler d1 migrations apply lifeos --remote
```

## 3. Cloudflare Access — zásadní bezpečnostní krok
1. V Cloudflare Zero Trust → Access controls → Applications → Add an application → **Self-hosted**.
2. Nastav doménu Worker API. Pro produkční provoz doporučujeme vlastní doménu, např. `api.tvoje-domena.cz`, namapovanou na Worker pomocí Worker Custom Domain. U `workers.dev` ověř dostupnost ochrany Access ve svém účtu; pokud ji nelze zapnout, použij vlastní doménu.
3. Vytvoř politiku **Allow** jen pro svůj e-mail (Emails / Emails ending in není totéž; zvol konkrétní e-mail).
4. V detailu Access aplikace najdi **Application Audience (AUD)** a vlož ho do `ACCESS_AUD`.
5. V Zero Trust najdi svůj team domain ve formátu `nazev.cloudflareaccess.com` a vlož do `ACCESS_TEAM_DOMAIN`.
6. V `worker/wrangler.jsonc` nastav `ALLOWED_EMAIL` přesně na svůj e-mail a `ALLOWED_ORIGIN` na přesnou adresu frontendu **bez koncového lomítka**, například `https://uzivatel.github.io` (origin neobsahuje cestu repozitáře).
7. Cloudflare Access chrání Worker; backend navíc na každém požadavku ověřuje JWT (issuer, audience, podpis, allowlist e-mailu).
8. Otevři `https://TVE-API/api/me` v prohlížeči a dokonči přihlášení přes Access. Poté otevři LifeOS a obnov stránku. Pro přístup mezi různými doménami může prohlížeč blokovat cookies třetích stran. **Doporučení:** vlastní doména pro frontend i API pod stejnou nadřazenou doménou, např. `lifeos.example.cz` a `api.example.cz`.

## 4. Worker deploy
Po úpravě `worker/wrangler.jsonc` spusť:

```bash
cd worker
npx wrangler deploy
```

Pokud potřebuješ změnit Access nastavení, uprav `worker/wrangler.jsonc` a nasaď znovu. Nikdy do GitHubu neukládej přístupové tokeny, hesla ani soukromé klíče.

## 5. Vlastní doména a base path
Workflow používá `VITE_BASE_PATH=/<název-repozitáře>/`. Pro vlastní doménu na kořeni webu změň ve `.github/workflows/deploy.yml` hodnotu `VITE_BASE_PATH` na `/`. V GitHub Settings → Pages přidej vlastní doménu a nastav DNS podle průvodce GitHubu. Uprav také `ALLOWED_ORIGIN` ve Workeru a konfiguraci Cloudflare Access.

## 6. iPhone
Otevři web v Safari → Sdílet → Přidat na plochu. Offline je dostupná pouze dříve načtená statická část aplikace; data a zápisy vyžadují online připojení. Při odhlášení nebo ztrátě připojení nejsou data synchronizována.

## 7. Aktualizace
Změny nahraj přes GitHub Desktop (Commit → Push); GitHub Actions sestaví frontend. Backend aktualizuj `cd worker && npx wrangler deploy`. Migrace spusť `npx wrangler d1 migrations apply lifeos --remote`.

## 8. Kontrola
- `npm run check` — TypeScript kontrola.
- `npm run build` — produkční frontend build.
- Ověř, že nepřihlášený přístup k `/api/me` je odmítnut.
- Ověř, že jiný e-mail z Access allowlistu nemá přístup.
- Ověř vytvoření, úpravu a smazání záznamu a persistenci po obnovení stránky.
- Ověř iPhone instalaci, navigaci a offline stav.

## Známá omezení této verze
Jde o funkční základ aplikace, **nikoli plnou implementaci všech detailů z rozsáhlého zadání**. Moduly sdílejí jednoduchý záznamový model. Chybí například Kanban s drag-and-drop, přehledy známek, plnohodnotný Markdown preview, grafy, vlastní přeuspořádání widgetů, detailní rozpočty a některé pokročilé statistiky. Zabezpečení a nasazení je nutné reálně otestovat na tvé doméně. Bez přístupu do účtů nelze potvrdit živé nasazení.
