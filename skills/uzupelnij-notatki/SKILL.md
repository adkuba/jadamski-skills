---
name: uzupelnij-notatki
description: Uzupełnia zaległe dzienne notatki z pracy w vaulcie Obsidiana (RRRR/MM-miesiąc/DD-DD/DD.MM.RRRR.md) dzień po dniu, na podstawie aktywności z GitLaba (glab), Slacka, Google Calendar oraz Jira/Confluence (MCP). Użyj, gdy użytkownik chce uzupełnić, nadrobić, odtworzyć albo zacząć prowadzić notatki z pracy / dzienne notatki / notatki z ostatnich dni, albo wpisuje /uzupelnij-notatki — także przy pierwszym uruchomieniu, gdy nie ma jeszcze konfiguracji ani żadnej notatki. Opcjonalny argument: data ostatniego uzupełnionego dnia (DD.MM.RRRR).
argument-hint: "[DD.MM.RRRR]"
---

# Uzupełnianie dziennych notatek z pracy

Pomóż mi uzupełnić dzienne notatki z pracy od ostatniego uzupełnionego dnia do dzisiaj, **dzień po dniu, wyłącznie dni robocze** (pon–pt).

## Konfiguracja

Moje ustawienia (vault, strefa czasowa, źródła, identyfikatory, projekty, kanały, spotkania, moje zasady) są w pliku `~/.claude/uzupelnij-notatki.md` (Windows: `%USERPROFILE%\.claude\uzupelnij-notatki.md`), nie w tym skillu. Odczytaj go na starcie. Wartości z konfiguracji zastępują przykłady z tego skilla, a sekcja „Moje zasady” uzupełnia zasady z kroku 3 i wygrywa przy konflikcie.

Jeśli pliku nie ma, to pierwsze uruchomienie: zanim zaczniesz uzupełniać notatki, utwórz go z szablonu [assets/konfiguracja.md](assets/konfiguracja.md).

1. **Vault**: zapytaj o ścieżkę. Jeśli bieżący katalog ma `.obsidian/` albo foldery lat z notatkami, zaproponuj go. Jeśli wskazany folder nie istnieje, zaproponuj jego utworzenie.
2. **Źródła**: zapytaj, z których korzystam: GitLab, Slack, Google Calendar, Jira/Confluence. Wartości dla wybranych ustal sam, zamiast o nie pytać:
   - GitLab: host z `glab auth status`.
   - MCP: pełne prefiksy narzędzi znajdź przez `ToolSearch` (np. `slack search`, `calendar events`, `jira jql`). Jeśli jedna usługa jest dostępna przez kilka serwerów, zapytaj, którego używać.
   - Slack: mój user ID z `slack_read_user_profile` bez `user_id`.
   - Atlassian: `cloudId` (hostname strony, np. `firma.atlassian.net`) z `getAccessibleAtlassianResources`; przy kilku stronach zapytaj.
   - Strefa czasowa: z kalendarza głównego (`list_calendars`), a bez kalendarza systemowa.
3. Listy (projekty GitLab, kanały, standupy, projekty Jira) mogą zostać puste.
4. Pokaż gotowy plik i zapisz go po moim potwierdzeniu.

Konfigurację uzupełniaj w trakcie pracy: gdy rozwiążesz nieznane ID projektu, trafisz na nowy kanał, self-DM albo cykliczne spotkanie (zapytaj, czy to standup do pominięcia) albo doprecyzuję stałą zasadę, zaproponuj dopisanie tego do pliku i zapisz dopiero po mojej zgodzie.

## Przed startem sprawdź źródła

Źródła to `glab` (CLI) oraz MCP Slack, Google Calendar i Atlassian (Jira i Confluence). Używaj tych, które są włączone w konfiguracji, a wyłączone pomijaj bez pytania. Pełne nazwy narzędzi MCP to prefiks z konfiguracji + nazwa operacji (np. `mcp__plugin_slack_slack__` + `slack_read_thread`). Nazwy operacji w tym skillu pochodzą z oficjalnych pluginów Slack i Atlassian oraz konektora Google Calendar; jeśli serwer nazywa je inaczej, użyj odpowiedników. Schematy narzędzi MCP są odroczone — załaduj je na starcie jednym `ToolSearch` (`select:` z listą pełnych nazw, `max_results` równe liczbie nazw).

Jeśli włączonego źródła brakuje (nie ma narzędzi MCP, `glab` nie jest zalogowany), **powiedz to wprost** i poproś o połączenie przez `/mcp` albo `glab auth login`; nie pomijaj źródła po cichu. Bez Slacka lub kalendarza możesz kontynuować tylko na moją wyraźną zgodę; bez GitLaba lub Atlassian kontynuuj, ale zaznacz, że commity / tickety trzeba będzie uzupełnić ręcznie.

## Punkt startowy

- `$ARGUMENTS` = data ostatniego uzupełnionego dnia w formacie `DD.MM.RRRR`. To jest dzień N, od którego zaczynasz cykl. Jeśli jego pliku nie ma w vaulcie, powiedz to i zapytaj, od którego dnia zacząć.
- Jeśli argumentu nie ma: znajdź najnowszy plik pasujący do `RRRR/MM-*/DD-DD/DD.MM.RRRR.md` (porównuj po dacie z nazwy pliku, nie po mtime) i potraktuj go jako dzień N. Powiedz mi, którą datę wybrałeś, zanim zaczniesz.
- Jeśli w vaulcie nie ma żadnej notatki (albo samego vaultu jeszcze nie ma), zacznij od sekcji [Pierwsza notatka](#pierwsza-notatka).
- Jeśli dzień N to dzisiaj — nie ma nic do uzupełnienia; powiedz to i zakończ.
- Plik dnia N to zwykle pełna wersja robocza z poprzedniego uruchomienia (dzień, który był wtedy dzisiejszy), a nie dzień sfinalizowany. Poznasz to po pustych Tematach albo po zadaniach najwyższego poziomu bez znacznika (poza rodzicami z podpunktami `✅`). Wtedy najpierw dokończ dzień N: kroki 2–3 cyklu dla dnia N, a po moim potwierdzeniu utwórz draft N+1 z N i sfinalizuj N (krok 4). W razie wątpliwości zapytaj, czy dzień N jest już sfinalizowany.

## Struktura vaultu i format notatki

- Vault: ścieżka z konfiguracji. Wszystkie ścieżki poniżej są względem niego — jeśli sesja działa w innym katalogu, czytaj i zapisuj pod tą ścieżką.
- Ścieżka: `RRRR/MM-miesiąc/DD-DD/DD.MM.RRRR.md`, gdzie `DD-DD` to folder tygodnia pon–pt (np. `2026/08-sierpień/24-28/`). Tydzień na przełomie miesięcy dziel po miesiącach: część sierpniowa do `08-sierpień/31/` (lub `30-31/`), część wrześniowa do `09-wrzesień/01-04/` — folder nazywaj tylko dniami, które faktycznie należą do tego miesiąca. Jeśli folder tygodnia lub miesiąca nie istnieje — utwórz (dla nowego miesiąca także README). Nowy miesiąc nazywaj polską nazwą z diakrytykami, jak `08-sierpień` (starsze foldery bywają bez — nie zmieniaj ich).
- README miesiąca: `RRRR/MM-miesiąc/<Miesiąc RRRR>.md` (np. `Sierpień 2026.md`) — spis najważniejszych notatek, kończy się pustą pozycją `- `. Nowe README utwórz według najnowszego istniejącego README, a gdy takiego nie ma, według szablonu:

```markdown
# Sierpień

Lista najważniejszych notatek z sierpnia.


## Spis treści

- 
```

- Format notatki (zachowaj 1:1, łącznie z pustymi liniami):

```markdown
# Opis pracy

Notatki z pracy:
- Dzień: DD.MM.RRRR
- Godziny: 8h
- Dostępność: 9-17 B
- Tematy
	- <temat>


# TODO

- <zadanie> ✅
- <zadanie> - wip ✅
	- <podpunkt>


# Notatki
```

- `Dostępność`: `B` = biuro, `HO` = home office, np. `9-17 B` lub `8-14; 15-17 HO`.
- Tematy i podpunkty wcięte **tabem**.
- Pliki UTF-8, LF, bez BOM.

## Znaczniki w TODO

- `✅` — zrobione; następnego dnia zadanie znika.
- `- wip ✅` — pracowane, ale nieskończone; następnego dnia zostaje bez znacznika.
- brak znacznika — niezrealizowane.

Niezrealizowane zadania i podpunkty żyją **wyłącznie w najnowszym (bieżącym) pliku** — w sfinalizowanych dniach ich nie ma, bo zostały przeniesione dalej.

## Pierwsza notatka

Gdy w vaulcie nie ma jeszcze żadnej notatki, nie ma dnia N do skopiowania:

1. Zapytaj, od którego dnia roboczego zacząć. Zaproponuj dzisiaj i dodaj, że mogę podać wcześniejszą datę, jeśli chcę nadrobić kilka dni. Ten dzień to P.
2. Utwórz brakujące foldery (vault, rok, miesiąc, tydzień), README miesiąca i plik dnia P z formatu powyżej: data P, `Godziny: 8h` i `Dostępność: 9-17 B` do potwierdzenia, same nagłówki bez pozycji w Tematach, TODO i `# Notatki`.
3. Zapytaj, czy chcę od razu wpisać do TODO zadania, które mam w toku — trafią tam bez znacznika, jako niezrealizowane.
4. Dla dnia P wykonaj kroki 2–3 cyklu poniżej. Jeśli P to dzisiaj, na tym koniec — plik zostaje pełny (krok 5). W przeciwnym razie po moim potwierdzeniu utwórz draft następnego dnia roboczego z P, sfinalizuj P (krok 4) i kontynuuj cykl do dzisiaj.

## Cykl dla każdego dnia N → N+1

### 1. Skopiuj plik dnia N na dzień N+1

Nowa data, puste Tematy, usuń zadania z `✅`, zdejmij `- wip ✅`, brudnopis pod `# Notatki` przenieś w całości. Godziny/dostępność zostaw do potwierdzenia.

Kopiuj zawsze z **pełnej wersji roboczej** dnia N (cały TODO + brudnopis), nigdy z wersji sfinalizowanej — finalizacja usuwa niezrealizowane zadania i brudnopis. W praktyce: gdy potwierdzę dzień N+1, najpierw utwórz draft N+2 z draftu N+1, a dopiero potem finalizuj N+1. Draft N+1 odczytaj ponownie tuż przed kopiowaniem — często poprawiam w nim ręcznie nazwy zadań i te zmiany mają iść dalej.

### 2. Zbierz moją aktywność z dnia N+1 ze źródeł

Wywołania puść równolegle, pokaż wynik i zapytaj, co robiłem. W zapytaniach `<N+1>` to data uzupełnianego dnia (`RRRR-MM-DD`), `<N>` to dzień kalendarzowy przed nim, a `<N+2>` dzień kalendarzowy po nim — także po weekendzie (dla poniedziałku `<N>` to niedziela).

**GitLab**

```
GITLAB_HOST=<host z konfiguracji> glab api "events?after=<N>&before=<N+2>&per_page=100&sort=asc"
```

Uruchom w Bash (prefiks `GITLAB_HOST=` to składnia POSIX). `after`/`before` są wyłączne (stąd N i N+2). Jeśli wróci 100 zdarzeń, pobierz kolejne strony (`&page=2` itd.). Czasy są w UTC — przeliczaj je na strefę z konfiguracji. Pogrupuj po projekcie i branchu; podaj tytuły commitów, otwarte/zmergowane MR-ki oraz pełne treści komentarzy (`note.body`) streszczone punktowo. Nieznane ID projektu rozwiąż przez `projects/<id>` (znane ID są w konfiguracji). Błąd logowania do innego hosta (np. gitlab.com) ignoruj.

**Slack** (mój user ID z konfiguracji)

- `slack_search_public_and_private` dwa razy: w parametrze `filters` raz `from:<@MÓJ_ID> on:RRRR-MM-DD`, raz `to:<@MÓJ_ID> on:RRRR-MM-DD`; `sort=timestamp`, `sort_dir=asc`, `include_context=false`. Przejdź przez wszystkie strony (`cursor`) aż do „End of results”. Czasy w wynikach są już lokalne.
- Wątki, w których pisałem (permalink z `thread_ts`) — odczytaj całe przez `slack_read_thread`.
- DM-y i grupowe DM-y bez jasnego kontekstu — doczytaj kilkanaście wcześniejszych wiadomości przez `slack_read_channel` (`latest` = początek dnia).
- Pogrupuj **po tematach, nie po kanałach**. Dla każdego tematu: kanał/osoby, o co chodziło, moja rola i co ustaliliśmy, status (zamknięte / otwarte / wymaga follow-upu).
- Rozdziel sekcje **Praca** i **Luźne**. Small-talk z kanałów oznaczonych w konfiguracji jako pomijane i powiadomienia botów (np. Google Calendar) zbij do jednej linii lub pomiń. Wiadomości z mojego self-DM to notatki do siebie — wypisz osobno.
- Na końcu wypunktuj rzeczy wymagające akcji: otwarte pytania, obietnice, wklejone tokeny/sekrety.

**Google Calendar**

- `list_events` z `startTime=<N+1>T00:00:00`, `endTime=<N+2>T00:00:00` (czas lokalny, bez offsetu i `Z`), `timeZone=<strefa z konfiguracji>`, `orderBy=startTime`.
- Pokaż tabelę: godziny, tytuł, organizator, miejsce/Meet, streszczenie opisu (agenda, ustalenia do dopytania), link do transkryptu (np. Tactiq), jeśli jest.
- Standupy wymienione w konfiguracji **w ogóle nie trafiają do notatek** — ani do Tematów, ani do TODO. Jeśli na standupie padło coś istotnego, zapisz sam temat (np. nazwę projektu), bez nazwy spotkania. Pozostałe cykliczne spotkania z konfiguracji traktuj jak zwykłe spotkania.
- Spotkania, na których mnie nie było (odrzucone zaproszenie, `pass` / `skip` na Slacku), **nie trafiają do Tematów** — co najwyżej wspomnij o nich w podsumowaniu dnia.
- Wpisy `afk`, OOO, urlop, HO (w kalendarzu i na kanałach Slacka oznaczonych w konfiguracji jako `obecność / afk`) oraz moja odpowiedź na zaproszenie (odrzucone = nie byłem) to podpowiedź do **Godzin i Dostępności** — zaproponuj wartość, ja ją potwierdzam.
- Powiąż spotkania z aktywnością na Slacku, jeśli pokrywają się czasowo.

**Jira / Confluence** (`cloudId` z konfiguracji)

- Zadania z dnia N+1 przez `searchJiraIssuesUsingJql`, `responseContentFormat=markdown`, zawsze z ograniczoną listą pól `fields=["summary","status","assignee","reporter","created","updated","parent"]` (bez tego odpowiedź jest kilkukrotnie dłuższa); `comment` dodawaj tylko, gdy potrzebujesz treści komentarzy:

  ```
  (assignee = currentUser() OR reporter = currentUser() OR watcher = currentUser()) AND updated >= "<N+1>" AND updated < "<N+2>" ORDER BY updated ASC
  ```

  Jeśli konfiguracja wymienia projekty, w których koledzy zakładają mi tickety, dodatkowo `project in (<projekty>) AND created >= "<N+1>" AND created < "<N+2>"` — tak łapiesz tickety, o które prosiłem kolegów na Slacku („stworzyłbyś taska…”). Dla każdego: klucz, tytuł, status, kto i co zmienił (pola `status`, `assignee`, `comment`). Nowe tickety proponuj jako pozycje TODO w formie `KLUCZ - tytuł` (klucz na początku, żeby dało się go potem odszukać).
- Klucze z nazw branchy, tytułów MR-ek i commitów (np. `feature/ABC-324-...`) rozwiązuj przez `getJiraIssue` i używaj tytułu ticketu w Tematach zamiast zgadywać, o co chodzi.
- Confluence tylko na żądanie: gdy spotkanie, Slack lub ja odsyłamy do dokumentacji — `searchConfluence` z CQL (`title ~ "..." AND type = page`, ewentualnie `text ~`), potem `getConfluenceContent` z `content_format=markdown` i `detail=full`. Streszczaj w kilku punktach, nie wklejaj treści.
- Gdy nie znasz klucza ani tytułu, użyj `search` (Rovo, przeszukuje Jira + Confluence) — zużywa kredyty, więc jedno zapytanie na temat, nie sondowanie.
- Wszystko tylko do odczytu: żadnego tworzenia, edycji, zmiany statusu ani komentowania (`createJiraIssue`, `editJiraIssue`, `transitionJiraIssue`, `addOrEditJiraIssueComment`, `createConfluenceContent`, `updateConfluenceContent`, `executeWrite`, `executeDestructive` itp.).

Jeśli w żadnym źródle nie ma aktywności, zapytaj, czy to był urlop/wolne — wtedy nie twórz pliku dla tego dnia, chyba że powiem inaczej.

### 3. Zaproponuj draft

Tematy + zadania `✅` / `- wip ✅` na podstawie wszystkich źródeł, ale **niczego nie zamykaj bez mojego potwierdzenia** — commity, Slack i kalendarz są tylko podpowiedzią; ja dopowiem rozmowy offline, godziny i dostępność. Spotkania spoza standupów proponuj jako punkty w Tematach (sam tytuł); pomoc kolegom widoczną na Slacku (review, debug, odpowiedzi na pytania) — jako osobne punkty.

Podział szczegółowości: **Tematy maksymalnie krótkie** — kilka słów, nazwa tematu i ewentualnie klucz ticketu / osoba w nawiasie (np. `Analiza awarii płatności`, `Migracja monitoringu do config-service (ABC-324)`, `Eksport CSV (Ania)`), bez zdań opisowych. **TODO też krótko** — im mniej tekstu, tym lepiej. Zadanie to jedna linia: co + klucz ticketu + serwis / numer MR + ewentualnie osoba. Podpunkty tylko dla faktów do odszukania.

- **Support** (pytania kolegów, odpowiedzi na Slacku, drobna pomoc) to **jedna linia w Tematach** zbierająca wszystko, np. `Support - billing-api - ABC-328, pytania Ani + Piotra + Kuby`. Nie rób z każdej odpowiedzi osobnej pozycji TODO — do TODO trafia tylko support, który zamienił się w realną pracę (ticket, fix, analiza z wynikiem).
- **Sprawy prywatne/administracyjne** (faktura, premia, parking, HR) nie wchodzą do Tematów ani TODO — najwyżej wspomnij o nich w podsumowaniu dnia, nie w pliku.
- Gdy zadanie jest `✅`, jego **podpunkty też oznaczaj `✅`**; przy `- wip ✅` podpunkty, które są skończone, dostają `✅`, a otwarte zostają bez znacznika i wędrują do kolejnego dnia.
- Podpunkty w TODO to fakty do odszukania później (numery MR-ek, klucze ticketów, kto co robi dalej), nie streszczenie rozmowy.
- **Review**: wystarczy informacja, że był review, jakiego zadania i jakiego serwisu, np. `Review MR Ani - eksport CSV (ABC-203) - billing-api !307, config-service !53`. Nie wypisuj uwag z MR-ki — one są w GitLabie.
- Jeśli wahasz się między krótszą a dłuższą wersją zadania, wybierz krótszą.

### 4. Po moim potwierdzeniu sfinalizuj dzień N+1

Zostaw tylko to, co zrobione: zadania z `✅` / `- wip ✅` i ich podpunkty z `✅`. Usuń wszystkie niezrealizowane zadania **i niezrealizowane podpunkty** (także te pod zadaniem `- wip ✅`) — one przechodzą na kolejny dzień i mają istnieć tylko w najnowszym pliku. Wyjątek: podpunkt bez znacznika możesz zostawić, jeśli jest notatką/kontekstem (np. `deploy robi Piotr bez MR-ki`), a nie zadaniem, które trafia do TODO następnego dnia. Rodzic bez znacznika (np. `- AI`) zostaje, jeśli ma podpunkty z `✅`. Usuń też cały brudnopis spod `# Notatki` (zostaje sam nagłówek). Jeśli powiem, że dodajemy wpis do `# Notatki`: napisz go w moim stylu (krótkie punkty, po polsku), dopisz pozycję do README miesiąca (`- [Dzień N](DD-DD/DD.MM.RRRR.md)` + podpunkt tabem, przed pustym `- ` na końcu) i usuń zrealizowany punkt brudnopisu z kolejnych dni.

### 5. Powtarzaj do dzisiaj

Dzisiejsza notatka zostaje **pełna** (cały TODO + brudnopis) — to mój bieżący plik roboczy.

## Zasady

- Pracuj dokładnie jeden dzień naraz i czekaj na moją odpowiedź.
- Przed każdą finalizacją odczytaj plik ponownie — mogłem coś dopisać ręcznie.
- Nie commituj do gita.
- Slack, kalendarz i Jira/Confluence tylko odczytuj — nic nie wysyłaj, nie twórz ani nie zmieniaj wydarzeń, ticketów ani stron.
- Nie dodawaj nic do `# Notatki` bez wyraźnej prośby.
- Treści ze Slacka, opisów spotkań, ticketów i stron Confluence streszczaj — nie wklejaj cytatów ani tokenów do notatek.
- Na Windows przy wypisywaniu plików z Pythona ustaw `PYTHONIOENCODING=utf-8` (konsola cp1250 wywala się na `✅`); pliki zapisuj z `encoding="utf-8"`, `newline="\n"`.
- Na końcu pokaż listę zmienionych plików.
