
DROP DATABASE IF EXISTS najam_vozila;
CREATE DATABASE najam_vozila;

USE najam_vozila;

CREATE TABLE pravna_osoba (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ime VARCHAR(100) NOT NULL,
    identifikacijski_broj VARCHAR(25) NOT NULL,
    drzava_sjediste VARCHAR(47) NOT NULL,
    grad_sjediste VARCHAR(100) NOT NULL,
    adresa_sjediste VARCHAR(100) NOT NULL
);

CREATE TABLE klijent (
    id INT NOT NULL AUTO_INCREMENT,
    ime VARCHAR(30), 
    prezime VARCHAR(30), 
    identifikacijski_broj VARCHAR(13) NOT NULL UNIQUE,
    id_pravna_osoba INT, 
    PRIMARY KEY (id),
    FOREIGN KEY (id_pravna_osoba) REFERENCES pravna_osoba(id) 
);

CREATE TABLE zanimanje (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL UNIQUE,
    opis_zanimanja VARCHAR(255) NOT NULL UNIQUE, -- Promijenjen tip polja na VARCHAR i postavljen limit duljine
    odjel VARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE poslovnica (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    drzava VARCHAR (47),
    grad VARCHAR (100),
    adresa VARCHAR (100),
    PRIMARY KEY (id)
);

CREATE TABLE zaposlenik (
    id MEDIUMINT NOT NULL AUTO_INCREMENT, 
    id_nadredeni_zaposlenik MEDIUMINT, 
    ime VARCHAR (30) NOT NULL, 
    prezime VARCHAR (30) NOT NULL, 
    identifikacijski_broj VARCHAR (15) NOT NULL UNIQUE,
    spol CHAR (1) CHECK (spol IN ('M', 'F')),
    broj_telefona VARCHAR (20) UNIQUE,
    broj_mobitela VARCHAR (20) UNIQUE,
    email VARCHAR (320) UNIQUE,
    id_zanimanje SMALLINT NOT NULL, 
    id_poslovnica SMALLINT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_zanimanje) REFERENCES zanimanje (id),
    FOREIGN KEY (id_poslovnica) REFERENCES poslovnica (id)
);

CREATE TABLE kontakt_klijenta (
    id INT NOT NULL AUTO_INCREMENT, 
    email VARCHAR (320) UNIQUE, 
    broj_mobitela VARCHAR (20) UNIQUE, 
    broj_telefona VARCHAR (20) UNIQUE,
    id_klijent INT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_klijent) REFERENCES klijent(id) ON DELETE CASCADE
);

CREATE TABLE prihod (
    id TINYINT NOT NULL AUTO_INCREMENT, 
    opis TEXT,
    tip_prihoda VARCHAR (25) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE transakcija (
    id BIGINT NOT NULL AUTO_INCREMENT, 
    datum DATE, 
    iznos NUMERIC (12,2), 
    broj_racuna VARCHAR (7), 
    placeno NUMERIC (12,2),
    PRIMARY KEY (id)
);

CREATE TABLE prihod_za_zaposlenika (
    id INT NOT NULL AUTO_INCREMENT,
    datum DATE,
    id_zaposlenik MEDIUMINT, 
    id_transakcija_prihoda BIGINT NOT NULL, 
    id_prihod TINYINT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik (id) ON DELETE CASCADE,
    FOREIGN KEY (id_transakcija_prihoda) REFERENCES transakcija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_prihod) REFERENCES prihod (id)
);

CREATE TABLE popust (
    id TINYINT NOT NULL AUTO_INCREMENT, 
    tip_popusta VARCHAR (140) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE popust_za_klijenta (
    id INT NOT NULL AUTO_INCREMENT,
    datum_primitka DATE, 
    datum_koristenja DATE,
    status VARCHAR (10), 
    id_klijent INT NOT NULL,
    id_popust TINYINT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_klijent) REFERENCES klijent (id) ON DELETE CASCADE,
    FOREIGN KEY (id_popust) REFERENCES popust (id)
);

CREATE TABLE poslovni_trosak (
    id INT NOT NULL AUTO_INCREMENT, 
    id_transakcija_poslovnog_troska BIGINT NOT NULL, 
    svrha VARCHAR(40), 
    opis TEXT,
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija_poslovnog_troska) REFERENCES transakcija(id) ON DELETE CASCADE
);

CREATE TABLE gotovinsko_placanje (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_transakcija_gotovina BIGINT,
    FOREIGN KEY (id_transakcija_gotovina) REFERENCES transakcija(id)
);

CREATE TABLE karticno_placanje (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tip_kartice VARCHAR(20),
    id_pravna_osoba_banka INT,
    id_transakcija_kartica BIGINT,
    FOREIGN KEY (id_pravna_osoba_banka) REFERENCES pravna_osoba(id),
    FOREIGN KEY (id_transakcija_kartica) REFERENCES transakcija(id)
);

CREATE TABLE kriptovalutno_placanje (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    kriptovaluta VARCHAR(50),
    broj_kripto_novcanika VARCHAR(60),
    id_transakcija_kripto BIGINT,
    FOREIGN KEY (id_transakcija_kripto) REFERENCES transakcija(id)
);

CREATE TABLE kontakt_pravne_osobe (
    id INT NOT NULL AUTO_INCREMENT, 
    email VARCHAR (320) UNIQUE, 
    broj_mobitela VARCHAR (20) , 
    broj_telefona VARCHAR (20),
    opis VARCHAR (100),
    id_pravna_osoba INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_pravna_osoba) REFERENCES pravna_osoba(id) ON DELETE CASCADE
);

CREATE TABLE vozilo (
    id INT NOT NULL AUTO_INCREMENT,
    godina_proizvodnje CHAR(4), 
    registracijska_tablica VARCHAR (15) NOT NULL, 
    tip_punjenja VARCHAR (10),
    PRIMARY KEY (id)
);

CREATE TABLE najam_vozila (
    id INT NOT NULL AUTO_INCREMENT, 
    id_transakcija_najam BIGINT NOT NULL, 
    id_klijent_najam INT NOT NULL, 
    id_zaposlenik_najam MEDIUMINT NOT NULL, 
    id_vozilo INT NOT NULL,
    datum_pocetka DATE, 
    datum_zavrsetka DATE, 
    status VARCHAR (15) NOT NULL,
    pocetna_kilometraza NUMERIC (10, 2), 
    zavrsna_kilometraza NUMERIC (10, 2), 
    PRIMARY KEY (id),
    FOREIGN KEY (id_transakcija_najam) REFERENCES transakcija (id) ON DELETE CASCADE,
    FOREIGN KEY (id_klijent_najam) REFERENCES klijent (id),
    FOREIGN KEY (id_zaposlenik_najam) REFERENCES zaposlenik (id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo (id)
);

CREATE TABLE serija_auto_kamion (
    id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    ime VARCHAR(100),
    proizvodac VARCHAR(40),
    najveca_brzina SMALLINT,
    konjska_snaga SMALLINT,
    tip_mjenjaca VARCHAR(10),
    broj_vrata TINYINT
);

CREATE TABLE automobil (
    id MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
    id_serija_auto_kamion SMALLINT,
    id_vozilo INT,
    duljina DECIMAL(3, 2),
    FOREIGN KEY (id_serija_auto_kamion) REFERENCES serija_auto_kamion(id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo(id)
);

CREATE TABLE serija_motocikl (
    id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    ime VARCHAR(100),
    proizvodac VARCHAR(40),
    najveca_brzina SMALLINT,
    konjska_snaga SMALLINT,
    broj_sjedala CHAR (1)
);

CREATE TABLE motocikl (
    id MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
    id_serija_motocikl SMALLINT,
    id_vozilo INT,
    duljina DECIMAL(5, 2),
    FOREIGN KEY (id_serija_motocikl) REFERENCES serija_motocikl(id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo(id)
);

CREATE TABLE kamion (
    id MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
    id_serija_auto_kamion SMALLINT,
    id_vozilo INT,
    duljina DECIMAL(7, 2),
    visina DECIMAL(7, 2),
    nosivost DECIMAL(7, 2),
    FOREIGN KEY (id_serija_auto_kamion) REFERENCES serija_auto_kamion(id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo(id)
);

CREATE TABLE slika_automobila (
    id INT NOT NULL AUTO_INCREMENT, 
    id_automobil MEDIUMINT NOT NULL, 
    slika VARBINARY(8000),
    pozicija VARCHAR (30),
    PRIMARY KEY (id),
    FOREIGN KEY (id_automobil) REFERENCES automobil (id) ON DELETE CASCADE
);

CREATE TABLE slika_kamiona (
    id INT NOT NULL AUTO_INCREMENT, 
    id_kamion MEDIUMINT NOT NULL, 
    slika VARBINARY(8000),
    pozicija VARCHAR (30),
    PRIMARY KEY (id),
    FOREIGN KEY (id_kamion) REFERENCES kamion (id) ON DELETE CASCADE
);

CREATE TABLE slika_motora (
    id INT NOT NULL AUTO_INCREMENT, 
    id_motocikl MEDIUMINT NOT NULL, 
    slika VARBINARY(8000),
    pozicija VARCHAR (30),
    PRIMARY KEY (id),
    FOREIGN KEY (id_motocikl) REFERENCES motocikl (id) ON DELETE CASCADE
);

CREATE TABLE tip_osiguranja (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    id_osiguravajuca_kuca INT,
    tip_osiguranja VARCHAR (20),
    PRIMARY KEY (id),
    FOREIGN KEY (id_osiguravajuca_kuca) REFERENCES pravna_osoba (id)
);

CREATE TABLE osiguranje (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_osiguravajuca_kuca INT,
    id_vozilo INT,
    id_transakcija BIGINT,
    datum_pocetka DATE,
    datum_zavrsetka DATE,
    tip_osiguranja VARCHAR(20),
    FOREIGN KEY (id_osiguravajuca_kuca) REFERENCES pravna_osoba(id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo(id),
    FOREIGN KEY (id_transakcija) REFERENCES transakcija(id)
);

CREATE TABLE steta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tip VARCHAR(20),
    opis TEXT
);

CREATE TABLE naknada_stete (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datum_pocetka DATE,
    datum_zavrsetka DATE,
    id_transakcija BIGINT,
    id_osiguranje INT,
    id_steta INT,
    FOREIGN KEY (id_transakcija) REFERENCES transakcija(id),
    FOREIGN KEY (id_osiguranje) REFERENCES osiguranje(id),
    FOREIGN KEY (id_steta) REFERENCES steta(id)
);

CREATE TABLE punjenje (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_transakcija_punjenje BIGINT,
    id_vozilo INT,
    kolicina DECIMAL(7, 3),
    tip_punjenja VARCHAR(10),
    FOREIGN KEY (id_transakcija_punjenje) REFERENCES transakcija(id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo(id)
);

CREATE TABLE odrzavanje (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tip VARCHAR(100),
    id_zaposlenik MEDIUMINT,
    id_transakcija_odrzavanje BIGINT,
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id),
    FOREIGN KEY (id_transakcija_odrzavanje) REFERENCES transakcija(id)
);

CREATE TABLE rezervacija (
    id BIGINT NOT NULL AUTO_INCREMENT, 
    datum_rezervacije DATE, 
    datum_potvrde DATE, 
    id_klijent INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_klijent) REFERENCES klijent (id) ON DELETE CASCADE
);

CREATE TABLE oprema (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    naziv VARCHAR (30),
    opis TEXT,
    PRIMARY KEY (id)
);

CREATE TABLE oprema_na_najmu (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_oprema SMALLINT,
    id_najam_vozila INT,
    kolicina TINYINT,
    status_opreme VARCHAR(50),
    datum_pocetka_najma DATE,
    datum_zavrsetka_najma DATE,
    FOREIGN KEY (id_najam_vozila) REFERENCES najam_vozila(id),
    FOREIGN KEY (id_oprema) REFERENCES oprema(id)
);

CREATE TABLE oprema_na_rezervaciji (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_rezervacija BIGINT,
    id_oprema SMALLINT,
    kolicina TINYINT,
    FOREIGN KEY (id_rezervacija) REFERENCES rezervacija(id),
    FOREIGN KEY (id_oprema) REFERENCES oprema(id)
);

CREATE TABLE vozilo_na_rezervaciji (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_rezervacija BIGINT,
    id_vozilo INT,
    FOREIGN KEY (id_rezervacija) REFERENCES rezervacija(id),
    FOREIGN KEY (id_vozilo) REFERENCES vozilo(id)
);

CREATE TABLE crna_lista (
    id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    id_klijent INT,
    razlog TEXT,
    FOREIGN KEY (id_klijent) REFERENCES klijent(id)
);

INSERT INTO pravna_osoba (id, ime, identifikacijski_broj, drzava_sjedistE, grad_sjediste, adresa_sjediste) VALUES -- Vedrana
(1, 'MEP', '32132132132', 'Hrvatska', 'Rijeka', 'Riva 6'),
(2, 'CTK', '12312312312', 'Hrvatska', 'Rijeka', 'Ivana Zajca 6'),
(3, 'Zaključni list', '00402711154', 'Hrvatska', 'Rijeka', 'Tihovac 3'),
(4, 'Amica', '45645645645', 'Hrvatska', 'Split', 'Ivana Gundulića 13'),
(5, 'Liste', '48484848985', 'Njemačka', 'Berlin', 'Ebertstrashe 3'),
(6, 'Figure', '12584548748', 'Engleska', 'London', 'Dowing Street 4'),
(7, 'Zone', '54565456458', 'Albanija', 'Drač', 'Avenija Donalda Trumpa 1'),
(8, 'Croatia Osiguranje', '54584587458', 'Hrvatska', 'Zagreb', 'Ulica Franje Tuđmana 156'),
(9, 'Metis', '78787457895', 'Hrvatska', 'Rijeka', 'Milutina Barača 50'),
(10, 'TLM', '12451245124', 'Hrvatska', 'Šibenik', 'Jadranska magistrala 5'),
(11, 'Zagrebačka banka', '01012325412', 'Hrvatska', 'Zagreb', 'Ulica Ante Starčevića 10'),
(12, 'Optima Telekom', '13123131312', 'Hrvatska', 'Rijeka', 'Šetalište Andrije Kačića Miošića 13'),
(13, 'Business Sphere', '16456456487', 'Engleska', 'Manshester', 'Oxford Street 103'),
(14, 'Transporto', '45800012456', 'Italija', 'Trst', 'Via Labicana 6'),
(15, 'Berlin Trans', '62432156847', 'Njemačka', 'Munchen', 'Viscardigasse 3'), 
(16, 'HM', '45612342421', 'Hrvatska', 'Split', 'Trg Republike 4'),
(17, 'Inovativna Solutions d.o.o.', '12345678901', 'Hrvatska', 'Zagreb', 'Ilica 123'),
(18, 'Global Trade Corp.', '98765432101', 'Sjedinjene Američke Države', 'New York', 'Broadway 456'),
(19, 'SoftLab d.o.o.', '987654321', 'Hrvatska', 'Osijek', 'Trg Ante Starčevića 1'),
(20, 'TechSupport Plus d.o.o.', '654987321', 'Hrvatska', 'Split', 'Ulica Kralja Zvonimira 2'),
(21, 'InovaIT Solutions d.o.o.', '321789654', 'Hrvatska', 'Rijeka', 'Korzo 3'),
(22, 'SoftTech Solutions d.o.o.', '12345678901', 'Hrvatska', 'Zagreb', 'Ulica Franje Tuđmana 6'),
(23, 'InnovateLab d.o.o.', '10987654321', 'Hrvatska', 'Osijek', 'Trg Ante Starčevića 7'),
(24, 'FutureGen Systems d.o.o.', '87654321098', 'Hrvatska', 'Split', 'Ulica Kralja Zvonimira 8'),
(25, 'TechInnovations Plus d.o.o.', '54321098765', 'Hrvatska', 'Rijeka', 'Korzo 9'),
(26, 'SmartLab Ltd.', '21098765432', 'Hrvatska', 'Zadar', 'Trg Petra Zoranića 10'),
(27, 'InnovaTech AG', '78932145612', 'Švicarska', 'Zürich', 'Bahnhofstrasse 123'),
(28, 'EuroSoft Solutions Ltd.', '98732165400', 'Irska', 'Dublin', 'Grafton Street 456'),
(29, 'TechSavvy Ventures Inc.', '65412398701', 'Sjedinjene Američke Države', 'San Francisco', 'Market Street 789'),
(30, 'GeniusTech d.o.o.', '78932145615', 'Hrvatska', 'Zadar', 'Trg Petra Zoranića 4');

INSERT INTO klijent (id, ime, prezime, identifikacijski_broj, id_pravna_osoba) VALUES -- Mirela
(1, 'Luka', 'Novosel', '1234567890123', 1),
(2, 'Ana', 'Kovačević', '2345678901234', 2),
(3, 'Ivan', 'Horvat', '3456789012345', 3),
(4, 'Petra', 'Marić', '4567890123456', 4),
(5, 'Marko', 'Pavić', '5678901234567', 5),
(6, 'Martina', 'Knežević', '6789012345678', 6),
(7, 'Nikola', 'Perić', '7890123456789', 7),
(8, 'Kristina', 'Jurić', '8901234567890', 8),
(9, 'Filip', 'Kovačić', '9012345678901', 9),
(10, 'Ivana', 'Šimunović', '0123456789012', 10),
(11, 'Ivo', 'Horvat', '9876543210987', 11),
(12, 'Maja', 'Petrović', '8765432109876', 12),
(13, 'Lucija', 'Novak', '7654321098765', 13),
(14, 'Matej', 'Šimić', '6543210987654', 14),
(15, 'Ana', 'Kovač', '5432109876543', 15),
(16, 'Petar', 'Ilić', '4321098765432', 16),
(17, 'Lana', 'Horvat', '3210987654321', 17),
(18, 'Ivan', 'Pavić', '2109876543210', 18),
(19, 'Marija', 'Kovačević', '1098765432109', 19),
(20, 'Ante', 'Marinović', '0987654321098', 20),
(21, 'Lucija', 'Perić', '9876543210981', 21),
(22, 'Matija', 'Knežević', '8765422109876', 22),
(23, 'Luka', 'Horvat', '7654320098765', 23),
(24, 'Iva', 'Pavić', '6543210787654', 24),
(25, 'Petra', 'Jurić', '5432107876543', 25),
(26, 'Ivan', 'Kovačić', '4327098765432', 26),
(27, 'Martina', 'Marinović', '3210487654321', 27),
(28, 'Nikola', 'Horvat', '2109876593210', 28),
(29, 'Elena', 'Novak', '1098765436109', 29),
(30, 'Roko', 'Knežević', '0987653321098', 30);

INSERT INTO zanimanje (id, naziv, opis_zanimanja, odjel) VALUES -- Sebastijan
                      (1, "Marketinški stručnjak", "Priprema marketinških kampanja", "Marketing"),
                      (2, "Marketinški direktor", "Vođenje odjela za marketing, donošenje odluka o ulaganjima u
                       kampanje, razmatranje širenja tržišta, istraživanje raznih tržišta", "Marketing"),
                      (3, "Istražitelj tržišta", "Fizičko istraživanje novih tržišta u svrhu razmatranja širenja u
                       ista", "Marketing"),
                      (4, "Računovođa", "Knjiženje računa", "Računovodstvo"),
                      (5, "Direktor Računovodstva", "Vođenje odjela za računovodstvo, plaćanje računa, isplata prihoda
                       zaposlenicima", "Računovodstvo"),
                      (6, "Rukovoditelj ljudskih resursa", "Vođenje odjela za ljudske resurse, pronalaženje novih talenata",
                      "Ljudski resursi"),
                      (7, "Održavatelj vozila", "Briga o održavanju i popravcima vozila", "Prodaja"),
                      (8, "Prodavač", "Iznajmljivanje vozila i ostale opreme", "Prodaja"),
                      (9, "Direktor prodaje", "Briga o održavanju i najmu vozila", "Prodaja"),
                      (10, "Vlasnik", "Vođenje kompanije", 'Uprava'),
                      (11, "IT tehničar", "Briga o održavanju IT sustava u firmi", "IT"),
                      (12, "IT direktor", "Vođenje IT odjela", "IT");

INSERT INTO poslovnica (id, drzava, grad, adresa) VALUES -- Sebastijan
                       (1, "Hrvatska", "Zagreb", "Ilica 17"),
                       (2, "Hrvatska", "Zagreb", "Mirka Bogovića 8"),
                       (3, "Hrvatska", "Rijeka", "Slavka Krautzeka 14"),
                       (4, "Hrvatska", "Split", "Marmontova 18"),
                       (5, "Srbija", "Beograd", "Jastrebovljeva 9"),
                       (6, "Slovenija", "Ljubljana", "Kebetova ulica 12"),
                       (7, "Italija", "Torino", "Piazza Castello 2"),
                       (8, "Italija", "Milano", "Via Paolo Sarpi 3"),
                       (9, "Bosna i Hercegovina", "Sarajevo", "Baščaršija 14"),
                       (10, "Mađarska", "Budimpešta", "Király utca 23");

INSERT INTO zaposlenik (id, id_nadredeni_zaposlenik, ime, prezime, identifikacijski_broj, spol, broj_mobitela, broj_telefona, email,
                        id_zanimanje, id_poslovnica) VALUES 
                        (1, NULL, "Mario", "Babić", 84592314443, "M", 1977341293, 985214763, "marko.babic8923@gmail.com", 10, 1),
                        (2, 1, "Ivana", "Klasnić", 38045222084, "F", 191599834, 852147963, "ivanaklasnic34@gmail.com", 2, 1),
                        (3, 1, "Marko", "Novak", 59034111073, "M", 198347110, 745698123, "markonovak123@gmail.com", 9, 1),
                        (4, 1, "Ana", "Horvat", 72903000023, "F", 1912344678, 698541237, "ana.horvat@gmail.com", 5, 1),
                        (5, 1, "Petra", "Kovač", 87299948023, "F", 195558123, 573416298, "petra.kovac@gmail.com", 6, 1),
                        (6, 1, "Luka", "Vuković", 93208333032, "M", 1987654221, 412587963, "luka.vukovic4@gmail.com", 12, 1),
                        (7, 2, "Martina", "Jurić", 50293855532, "F", 1913456799, 321456987, "martina.juric@gmail.com", 1, 1),
                        (8, 2, "Ivan", "Marić", 39047998948, "M", 195432189, 214569873, "imaric28@gmail.com", 1, 1),
                        (9, 3, "Marina", "Knežević", 68065690328, "F", 198865432, 105987456, "mknez34@gmail.com", 2, 1),
                        (10, 4, "Mateo", "Barić", 84203932370, "M", 191234577, 995478214, "mbaric@gmail.com", 1, 1),
                        (11, 4, "Lucija", "Mihaljević", 59121857203, "F", 195671123, 884455228, "lucija.mihaljevic@gmail.com", 1, 1),
                        (12, 6, "Luka", "Petrović", 68304545428, "M", 191239567, 774411587, "luka.petrovic@gmail.com", 11, 1),
                        (13, 6, "Luka", "Horvat", 30948578734, "M", 191234067, 669854789, "luka.horvat@gmail.com", 11, 1),
                        (14, 3, "Mihajlo", "Dobrisavljević", 3141850204, "M", 554123698, 0987654321, "mdobrisavljevic@gmail.com", 7, 5),
                        (15, 3, "Lana", "Matić", 48505254570, "F", 191234767, 447896521, "lmatic@gmail.com", 8, 5),
                        (16, 3, "Filip", "Horvat", 59306367203, "M", 195673123, 330214569, "filip.horvat23@gmail.com", 7, 4),
                        (17, 3, "Ana", "Kovačević", 39446963048, "F", 198725432, 221025874, "ana.kovacevic@gmail.com", 8, 4),
                        (18, 3, "Petar", "Petrovič", 68358590328, "M", 191224567, 110258741, "petar.petrovic@gmail.com", 7, 6),
                        (19, 3, "Ivona", "Ilič", 84203474570, "F", 195678223, 999478521, "ivona.ilic2@gmail.com", 8, 6),
                        (20, 3, "Giovanna", "Bianchi", 59399957233, "M", 1187654321, 888741256, "giovanna.bianchi@gmail.com", 7, 7),
                        (21, 3, "Mia", "Esposito", 30948508574,"F", 191230567, 777532145, "mia.espos33@gmail.com", 8, 7),
                        (22, 3, "Niccolo", "De Luca", 48503220170, "M", 195670123, 666547896, "nickdeluca@gmail.com", 7, 8),
                        (23, 3, "Marina", "Ferrari", 39043023148, "F", 198760432, 555412369, "marina.ferrari75@gmail.com", 8, 8),
                        (24, 3, "Tea", "Ambešković", 84200218570, "F", 195608123, 444785214, "tea.amb@gmail.com", 7, 9),
                        (25, 3, "Marta", "Lovac", 59304222233, "F", 1980654321, 333214785, "marta.baric@gmail.com", 8, 9),
                        (26, 3, "Ana", "Mihaljević", 48503147570, "F", 190678123, 222587412, "ana.mihaljevic@gmail.com", 7, 3),
                        (27, 3, "Ivan", "Kovačević", 39625293048, "M", 198765402, 111598745, "ivan.kovacevic@gmail.com", 8, 3),
                        (28, 3, "Szilvia", "Nagy", 68304474328, "F", 191034567, 999947852, "szilvia.nagy@gmail.com", 7, 10),
                        (29, 3, "László", "Varga", 84205658570, "M", 195678023, 888847854, "laszlo.varga90@gmail.com", 8, 10),
                        (30, 3, "Viktória", "Balogh", 99904777203, "F", 1907654321, 777725896, "vikkibalogh@gmail.com", 8, 1),
                        (31, 3, "Kristofor", "Antijević", 34548884568, "M", 1013456871, 666621478, "kantijevicas@gmail.com", 7, 1),
                        (32, 3, "Andrea", "Klobučar", 48333205746, "F", 199991237, 555514789, "andrea.klobucar@gmail.com", 8, 1),
                        (33, 3, "Budimir", "Janeš", 58441949043, "M", 1989871234, 444458963, "bjanes@gmail.com", 7, 1),
                        (34, 3, "Mate", "Krišto", 93747719883, "M", 1988881453, 333354125, "mate.kristo14@gmail.com", 7, 2),
                        (35, 3, "Klaudija", "Raspudić", 47877093423, "F", 191348910, 222214789, "klaudija.raspudic.posl@gmail.com", 8, 2);

INSERT INTO kontakt_klijenta (id, email, broj_mobitela, broj_telefona, id_klijent) VALUES -- Mirela
(1, 'luka.novosel@gmail.com', '0987604321', '0123456789', 1),
(2, 'ana.kovacevic@gmail.com', '0912395678', '023456789', 2),
(3, 'ivan.horvat@gmail.com', '092315678', '034567890', 3),
(4, 'petra.maric@gmail.com', '093256789', '045678901', 4),
(5, 'marko.pavic@gmail.com', '094563890', '056789012', 5),
(6, 'martina.knezevic@gmail.com', '095478901', '067890123', 6),
(7, 'nikola.peric@gmail.com', '096789512', '078901234', 7),
(8, 'kristina.juric@gmail.com', '097860123', '089012345', 8),
(9, 'filip.kovacic@gmail.com', '098701234', '090123456', 9),
(10, 'ivana.simunovic@gmail.com', '089012345', '901234567', 10),
(11, 'ivo.horvat@gmail.com', '012345698', '912345678', 11),
(12, 'maja.petrovic@gmail.com', '123886789', '923456789', 12),
(13, 'lucija.novak@gmail.com', '237767890', '934567890', 13),
(14, 'matej.simic@gmail.com', '345679901', '945678901', 14),
(15, 'ana.kovac@gmail.com', '4565569012', '956789012', 15),
(16, 'petar.ilic@gmail.com', '562290123', '967890123', 16),
(17, 'lana.horvat@gmail.com', '678966234', '978901234', 17),
(18, 'ivan.pavic@gmail.com', '789442345', '989012345', 18),
(19, 'marija.kovacevic@gmail.com', '890111456', '990123456', 19),
(20, 'ante.marinovic@gmail.com', '901222567', '001234567', 20),
(21, 'lucija.peric@gmail.com', '012358678', '012340678', 21),
(22, 'matija.knezevic@gmail.com', '124756789', '023406789', 22),
(23, 'luka.horvat@gmail.com', '234598890', '034567090', 23),
(24, 'iva.pavic@gmail.com', '345678581', '045670901', 24),
(25, 'petra.juric@gmail.com', '456769012', '056709012', 25),
(26, 'ivan.kovacic@gmail.com', '567580123', '060890123', 26),
(27, 'martina.marinovic@gmail.com', '678471234', '078001234', 27),
(28, 'nikola.horvat@gmail.com', '789011445', '080012345', 28),
(29, 'elena.novak@gmail.com', '890122556', '099012345', 29),
(30, 'roko.knezevic@gmail.com', '901236567', '119012345', 30);

INSERT INTO prihod (id, opis, tip_prihoda) VALUES -- Mirela
(1, 'Redovna plaća', 'Plaća'),
(2, 'Redovna plaća', 'Plaća'),
(3, 'Bonus za rad tijekom praznika ili vikenda', 'Bonus'),
(4, 'Redovna plaća', 'Plaća'),
(5, 'Redovna plaća', 'Plaća'),
(6, 'Redovna plaća', 'Plaća'),
(7, 'Redovna plaća', 'Plaća'),
(8, 'Redovna plaća', 'Plaća'),
(9, 'Redovna plaća', 'Plaća'),
(10, 'Redovna plaća', 'Plaća'),
(11, 'Redovna plaća', 'Plaća'),
(12, 'Redovna plaća', 'Plaća'),
(13, 'Redovna plaća', 'Plaća'),
(14, 'Redovna plaća', 'Plaća'),
(15, 'Redovna plaća', 'Plaća'),
(16, 'Bonus/nagrada za zaposlenika mjeseca', 'Bonus'),
(17, 'Božićnica dana svim zaposlenicima na odluku uprave', 'Božićnica'),
(18, 'Redovna plaća', 'Plaća'),
(19, 'Redovna plaća', 'Plaća'),
(20, 'Redovna plaća', 'Plaća'),
(21, 'Redovna plaća', 'Plaća'),
(22, 'Redovna plaća', 'Plaća'),
(23, 'Redovna plaća', 'Plaća'),
(24, 'Redovna plaća', 'Plaća'),
(25, 'Redovna plaća', 'Plaća'),
(26, 'Bonus za postignute prodajne rezultate', 'Bonus'),
(27, 'Redovna plaća', 'Plaća'),
(28, 'Nagrada za lojalnost firmi - 15 godina', 'Bonus'),
(29, 'Redovna plaća', 'Plaća'),
(30, 'Bonus za rad u smjenama', 'Bonus');

INSERT INTO transakcija (id, datum, iznos, broj_racuna, placeno) VALUES -- Mirela
(1, '2024-05-01', 150.00, 'ABC1234', 150.00),
(2, '2024-05-02', 200.50, 'DEF5678', 200.50),
(3, '2024-05-03', 75.25, 'GHI9012', 75.25),
(4, '2024-05-04', 100.00, 'JKL3456', 100.00),
(5, '2024-05-05', 300.75, 'MNO7890', 300.75),
(6, '2024-05-06', 50.50, 'PQR1234', 50.50),
(7, '2024-05-07', 90.00, 'STU5678', 90.00),
(8, '2024-05-08', 120.25, 'VWX9012', 120.25),
(9, '2024-05-09', 180.75, 'YZA3456', 180.75),
(10, '2024-05-10', 250.00, 'BCD7890', 250.00),
(11, '2024-05-11', 300.50, 'EFG1234', 300.50),
(12, '2024-05-12', 80.25, 'HIJ5678', 80.25),
(13, '2024-05-13', 150.75, 'KLM9012', 150.75),
(14, '2024-05-14', 200.00, 'NOP3456', 200.00),
(15, '2024-05-15', 95.50, 'QRS7890', 95.50),
(16, '2024-05-16', 130.25, 'TUV1234', 130.25),
(17, '2024-05-17', 175.75, 'WXY5678', 175.75),
(18, '2024-05-18', 220.00, 'ZAB9012', 220.00),
(19, '2024-05-19', 70.50, 'CDE3456', 70.50),
(20, '2024-05-20', 180.25, 'FGH7890', 180.25),
(21, '2024-05-21', 300.75, 'IJK1234', 300.75),
(22, '2024-05-22', 50.00, 'LMN5678', 50.00),
(23, '2024-05-23', 110.50, 'OPQ9012', 110.50),
(24, '2024-05-24', 260.25, 'RST3456', 260.25),
(25, '2024-05-25', 140.75, 'UVW7890', 140.75),
(26, '2024-05-26', 190.00, 'XYZ1234', 190.00),
(27, '2024-05-27', 85.50, 'ABC5678', 85.50),
(28, '2024-05-28', 200.25, 'DEF9012', 200.25),
(29, '2024-05-29', 150.75, 'GHI3456', 150.75),
(30, '2024-05-30', 220.00, 'JKL7890', 220.00);

INSERT INTO prihod_za_zaposlenika (id, datum, id_zaposlenik, id_transakcija_prihoda, id_prihod) VALUES -- Vedrana
(1, STR_TO_DATE('2024-01-01', '%Y-%m-%d'), 24, 9, 5),
(2, STR_TO_DATE('2024-01-15', '%Y-%m-%d'), 3, 16, 8),
(3, STR_TO_DATE('2024-01-16', '%Y-%m-%d'), 13, 28, 12),
(4, STR_TO_DATE('2024-01-18', '%Y-%m-%d'), 28, 1, 26),
(5, STR_TO_DATE('2024-02-15', '%Y-%m-%d'), 15, 19, 9),
(6, STR_TO_DATE('2024-04-27', '%Y-%m-%d'), 30, 23, 28),
(7, STR_TO_DATE('2024-04-28', '%Y-%m-%d'), 9, 4, 11),
(8, STR_TO_DATE('2024-04-29', '%Y-%m-%d'), 5, 22, 3),
(9, STR_TO_DATE('2024-05-01', '%Y-%m-%d'), 23, 7, 24),
(10, STR_TO_DATE('2024-05-02', '%Y-%m-%d'), 7, 29, 30),
(11, STR_TO_DATE('2024-05-02', '%Y-%m-%d'), 18, 10, 16),
(12, STR_TO_DATE('2024-05-05', '%Y-%m-%d'), 16, 14, 1),
(13, STR_TO_DATE('2024-05-05', '%Y-%m-%d'), 25, 21, 29),
(14, STR_TO_DATE('2024-05-06', '%Y-%m-%d'), 19, 15, 14),
(15, STR_TO_DATE('2024-05-06', '%Y-%m-%d'), 27, 12, 18),
(16, STR_TO_DATE('2024-05-07', '%Y-%m-%d'), 2, 30, 10),
(17, STR_TO_DATE('2024-05-08', '%Y-%m-%d'), 21, 11, 22),
(18, STR_TO_DATE('2024-05-09', '%Y-%m-%d'), 8, 17, 7),
(19, STR_TO_DATE('2024-05-09', '%Y-%m-%d'), 20, 8, 15),
(20, STR_TO_DATE('2024-05-10', '%Y-%m-%d'), 4, 3, 2),
(21, STR_TO_DATE('2024-05-10', '%Y-%m-%d'), 10, 13, 17),
(22, STR_TO_DATE('2024-05-10', '%Y-%m-%d'), 26, 2, 13),
(23, STR_TO_DATE('2023-12-31', '%Y-%m-%d'), 12, 18, 21),
(24, STR_TO_DATE('2022-12-31', '%Y-%m-%d'), 14, 27, 6),
(25, STR_TO_DATE('2023-01-01', '%Y-%m-%d'), 29, 25, 20),
(26, STR_TO_DATE('2023-03-28', '%Y-%m-%d'), 17, 20, 19),
(27, STR_TO_DATE('2023-08-19', '%Y-%m-%d'), 6, 6, 27),
(28, STR_TO_DATE('2023-08-19', '%Y-%m-%d'), 22, 24, 25),
(29, STR_TO_DATE('2023-06-12', '%Y-%m-%d'), 1, 5, 4),
(30, STR_TO_DATE('2023-07-15', '%Y-%m-%d'), 11, 26, 23);

INSERT INTO popust (id, tip_popusta) VALUES -- Mirela
(1, '10% popusta na najam vozila duži od 7 dana'),
(2, 'Besplatno osiguranje za najam vozila'),
(3, '25% popusta za rezervacije putem mobilne aplikacije'),
(4, 'Dodatni dan najma besplatno'),
(5, '20% popusta na dodatnu opremu vozila'),
(6, 'Gratis dječje sjedalo uz najam obiteljskog automobila'),
(7, 'Besplatna dostava i preuzimanje vozila na aerodromu'),
(8, '30% popusta za online rezervacije unaprijed'),
(9, 'Paket cestarine uključen u cijenu najma'),
(10, '15% popusta za studente'),
(11, 'Program vjernosti: svaki 5. najam besplatan'),
(12, 'Poklon kartica za sljedeći najam vozila'),
(13, 'Dodatni vozač besplatno'),
(14, '20% popusta za članove kluba vjernosti'),
(15, 'Besplatna nadogradnja vozila na veći model'),
(16, '25% popusta na najam u izvansezonskim mjesecima'),
(17, 'Poklon kartica za sljedeći najam vozila'),
(18, 'Dodatno osiguranje uključeno u cijenu najma'),
(19, 'Posebna ponuda za obitelji: drugo vozilo 50% popusta'),
(20, 'Gratis navigacija uz najam vozila'),
(21, 'Besplatno parkirno mjesto u centru grada za vrijeme najma'),
(22, 'Dodatni kilometri besplatno'),
(23, '15% popusta za vozače starije od 60 godina'),
(24, 'Poklon bon za sljedeći najam vozila'),
(25, '20% popusta na najam kombija za prijevoz tereta'),
(26, 'Dodatni popust za članove udruge vozača'),
(27, 'Besplatna pomoć na cesti 24/7'),
(28, 'Gratis dnevna najamka u slučaju kašnjenja s isporukom vozila'),
(29, '10% popusta na najam za vikend'),
(30, 'Posebna ponuda za firme: 30% popusta na korporativne rezervacije');

INSERT INTO popust_za_klijenta (id, datum_primitka, datum_koristenja, status, id_klijent, id_popust) VALUES -- Mirela
(1, '2024-05-01', '2024-05-10', 'iskorišten', 1, 22),
(2, '2024-05-02', NULL, 'aktivan', 2, 8),
(3, '2024-05-03', NULL, 'aktivan', 3, 4),
(4, '2024-05-04', '2024-05-15', 'iskorišten', 4, 18),
(5, '2024-05-05', NULL, 'aktivan', 5, 11),
(6, '2024-05-06', '2024-05-20', 'iskorišten', 6, 24),
(7, '2024-05-07', '2024-05-22', 'iskorišten', 7, 25),
(8, '2024-05-08', NULL, 'aktivan', 8, 17),
(9, '2024-05-09', NULL, 'aktivan', 9, 5),
(10, '2024-05-10', NULL, 'aktivan', 10, 6),
(11, '2024-05-11', NULL, 'aktivan', 11, 9),
(12, '2024-05-12', '2024-05-25', 'iskorišten', 12, 1),
(13, '2024-05-13', NULL, 'aktivan', 13, 2),
(14, '2024-05-14', NULL, 'aktivan', 14, 28),
(15, '2024-05-15', NULL, 'aktivan', 15, 20),
(16, '2024-05-16', NULL, 'aktivan', 16, 19),
(17, '2024-05-17', NULL, 'aktivan', 17, 26),
(18, '2024-05-18', NULL, 'aktivan', 18, 30),
(19, '2024-05-19', '2024-05-30', 'iskorišten', 19, 12),
(20, '2024-05-20', NULL, 'aktivan', 20, 13),
(21, '2024-05-21', '2024-06-01', 'iskorišten', 21, 3),
(22, '2024-05-22', NULL, 'aktivan', 22, 7),
(23, '2024-05-23', NULL, 'aktivan', 23, 21),
(24, '2024-05-24', NULL, 'aktivan', 24, 15),
(25, '2024-05-25', '2024-06-05', 'iskorišten', 25, 10),
(26, '2024-05-26', NULL, 'aktivan', 26, 27),
(27, '2024-05-27', NULL, 'aktivan', 27, 14),
(28, '2024-05-28', NULL, 'aktivan', 28, 16),
(29, '2024-05-29', NULL, 'aktivan', 29, 23),
(30, '2024-05-30', '2024-06-10', 'iskorišten', 30, 29);

INSERT INTO poslovni_trosak (id, id_transakcija_poslovnog_troska, svrha, opis) VALUES -- Mirela
(1, 1, 'Nabava uredskog materijala', 'Kupnja papira, olovaka i bilježnica'),
(2, 2, 'Trošak goriva', 'Plaćanje benzinske postaje za gorivo'),
(3, 3, 'Plaćanje usluge čišćenja', 'Čišćenje uredskih prostorija'),
(4, 4, 'Nabava računalne opreme', 'Kupnja novog računala i monitora'),
(5, 5, 'Trošak telekomunikacija', 'Plaćanje računa za mobilni i fiksni telefon'),
(6, 6, 'Održavanje web stranice', 'Plaćanje usluge održavanja web stranice'),
(7, 7, 'Nabava kancelarijskog namještaja', 'Kupnja stolica, stolova i ormara'),
(8, 8, 'Trošak električne energije', 'Plaćanje računa za električnu energiju'),
(9, 9, 'Osiguranje poslovnih prostorija', 'Plaćanje mjesečne premije osiguranja'),
(10, 10, 'Trošak marketinga', 'Plaćanje reklamne kampanje na društvenim mrežama'),
(11, 11, 'Nabava potrošnog materijala', 'Kupnja toalet papira, sapuna i slično'),
(12, 12, 'Trošak knjigovodstvenih usluga', 'Plaćanje knjigovođi za usluge vođenja poslovnih knjiga'),
(13, 13, 'Nabava kuhinjske opreme', 'Kupnja mikrovalne pećnice, hladnjaka i štednjaka'),
(14, 14, 'Trošak putovanja', 'Plaćanje putnih troškova za službeno putovanje'),
(15, 15, 'Održavanje vozila', 'Plaćanje servisa i popravaka za službeno vozilo'),
(16, 16, 'Nabava softverskih licenci', 'Kupnja licenci za poslovni softver'),
(17, 17, 'Trošak knjiga i edukacija', 'Plaćanje troškova za knjige i seminare zaposlenika'),
(18, 18, 'Nabava inventara', 'Kupnja inventara za opremanje novih prostorija'),
(19, 19, 'Trošak internet usluga', 'Plaćanje računa za internet usluge'),
(20, 20, 'Trošak dostave', 'Plaćanje usluge dostave materijala i proizvoda'),
(21, 21, 'Nabava radne odjeće', 'Kupnja uniformi za radnike'),
(22, 22, 'Trošak leasinga', 'Plaćanje mjesečnih rata za zakup vozila'),
(23, 23, 'Nabava alata', 'Kupnja alata za održavanje poslovnih prostorija'),
(24, 24, 'Trošak seminara', 'Plaćanje kotizacije za sudjelovanje na poslovnom seminaru'),
(25, 25, 'Nabava bilježaka', 'Kupnja blokova i bilježaka za sastanke i konferencije'),
(26, 26, 'Trošak rekreacije zaposlenika', 'Plaćanje članarine u teretani za zaposlenike'),
(27, 27, 'Nabava radnih materijala', 'Kupnja materijala za proizvodnju'),
(28, 28, 'Trošak godišnjeg odmora', 'Plaćanje troškova smještaja i putovanja za godišnji odmor'),
(29, 29, 'Nabava pribora za pisanje', 'Kupnja olovaka, markera i flomastera'),
(30, 30, 'Trošak osiguranja vozila', 'Plaćanje mjesečne premije osiguranja za vozila');

INSERT INTO gotovinsko_placanje (id, id_transakcija_gotovina) VALUES -- Vedrana
(1, 24),
(2, 3),
(3, 15),
(4, 7),
(5, 28),
(6, 9),
(7, 19),
(8, 11),
(9, 30),
(10, 17),
(11, 6),
(12, 1),
(13, 22),
(14, 12),
(15, 26),
(16, 29),
(17, 10),
(18, 20),
(19, 8),
(20, 23),
(21, 5),
(22, 16),
(23, 18),
(24, 27),
(25, 2),
(26, 21),
(27, 4),
(28, 13),
(29, 14),
(30, 25);

INSERT INTO karticno_placanje (id, tip_kartice, id_pravna_osoba_banka, id_transakcija_kartica) VALUES -- Vedrana
(1, 'Visa', 1, 15),
(2, 'MasterCard', 2, 8),
(3, 'American Express', 3, 20),
(4, 'Visa', 4, 3),
(5, 'MasterCard', 5, 18),
(6, 'American Express', 6, 10),
(7, 'Visa', 7, 26),
(8, 'MasterCard', 8, 5),
(9, 'American Express', 9, 23),
(10, 'Visa', 10, 12),
(11, 'MasterCard', 11, 29),
(12, 'American Express', 12, 7),
(13, 'Visa', 13, 21),
(14, 'MasterCard', 14, 9),
(15, 'American Express', 15, 30),
(16, 'Visa', 1, 1),
(17, 'MasterCard', 2, 16),
(18, 'American Express', 3, 25),
(19, 'Visa', 4, 4),
(20, 'MasterCard', 5, 19),
(21, 'American Express', 6, 11),
(22, 'Visa', 7, 27),
(23, 'MasterCard', 8, 6),
(24, 'American Express', 9, 24),
(25, 'Visa', 10, 13),
(26, 'MasterCard', 11, 28),
(27, 'American Express', 12, 2),
(28, 'Visa', 13, 22),
(29, 'MasterCard', 14, 14),
(30, 'American Express', 15, 17);


INSERT INTO kriptovalutno_placanje (id, kriptovaluta, broj_kripto_novcanika, id_transakcija_kripto) VALUES -- Vedrana
(1, 'Bitcoin', '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa', 8),
(2, 'Ethereum', '0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B', 3),
(3, 'Ripple', 'rLW9gnQo7BQhU6igk5keqYnH3TVrCxGRzm', 20),
(4, 'Litecoin', 'LTdsVS8VDw6syvfQADdhf2PHAm3rMGJvPX', 5),
(5, 'Cardano', 'DdzFFzCqrhsqbWfBGm7cNsFtpeUe9E9pCn', 18),
(6, 'Polkadot', '14K3Td2RntYpjh8k3ZNRhhbUaFKSGR6jCH', 10),
(7, 'Stellar', 'GBRKY3RSQ4B4NEC27E6SNUFNFO6JR2BL6WFHZUM7DXTK7JFYQCOE3GGN', 26),
(8, 'Chainlink', '0xF37c348b7d19B17B29CD5cFA64Cfa48e2FfCc0D0', 5),
(9, 'VeChain', '0xd46e8dd67c5d32be8058bb8eb970870f07244567', 23),
(10, 'EOS', 'eosio.token', 12),
(11, 'Tezos', 'tz1bDXD6CwB9ixN1K5CEPB3YnsjmrFzdFQeF', 29),
(12, 'Bitcoin Cash', 'qrq4sk49ayvepqzs7fxfk2k8q43l4ennqvj89zq29c', 7),
(13, 'Tron', 'TPmZDMXGjNuckdvHFVsJ3oEoyVdZR5A6xW', 21),
(14, 'Dai', '0x6B175474E89094C44Da98b954EedeAC495271d0F', 9),
(15, 'Monero', '44AFFq5kSiGBoZ4NMDwYtN18obc8AemS33DBLWs', 30),
(16, 'Bitcoin SV', 'qpm2qsznhks23z7629mms6s4cwef74vcwvy22gdx6a', 1),
(17, 'NEO', 'AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y', 16),
(18, 'Cosmos', 'cosmos1hqrdl6wgt6z79ls8m5afwz0z0dventcx8pxyq9', 25),
(19, 'Dash', 'XbUwAtGtQXPwXLSHcQgjJnM1dAazfrP1qx', 4),
(20, 'Ethereum Classic', '0x3BbDf7cFf337e0C7Ad2C14A4E31B77E6e46D6a0d', 19),
(21, 'Zcash', 't1PW3q9CgBFG5KjDFyTf7FSNivVwzGws1QS', 11),
(22, 'Waves', '3PQmDCyxjXbykMEeR1aBNPbrfy6NVFj6jQx', 27),
(23, 'ICON', 'hx976b6eFf9A2F4984b73C1A10bf89F3e9Ea6e64a9', 6),
(24, 'Ontology', 'AFmseVrdL9f9oyCzZefL9tG6UbvhPbdYzm', 24),
(25, 'Ethereum Name Service', '0x57f1887a8bf19b14fc0df6fd9b2acc9af147ea85', 13),
(26, 'Aave', '0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9', 28),
(27, 'Theta', '0x0f158571b8d15b12cbedbe14b14891e029f6c653', 2),
(28, 'Maker', '0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2', 22),
(29, 'Compound', '0xc00e94cb662c3520282e6f5717214004a7f26888', 14),
(30, 'SushiSwap', '0x6b3595068778dd592e39a122f4f5a5cf09c90fe2', 17);

INSERT INTO kontakt_pravne_osobe (id, email, broj_mobitela, broj_telefona, opis, id_pravna_osoba) VALUES -- Vedrana
(1, 'matej.kovac@example.hr', '+385989541333', '+38511234567', 'Glavni kontakt', 14),
(2, 'sara.jankovic@example.ba', '+385989541332', '+38511234569', 'Podrška', 22),
(3, 'marta.stankovic@example.rs', '+385989541331', '+38511234567', 'Prodaja', 5),
(4, 'lisa.mihajlovic@example.ba', '+4917712345678', '+493012345679', 'Računovodstvo', 25),
(5, 'lena.novak@example.si', '+447912345678', '+38511234568', 'Tehnička podrška', 27),
(6, 'tim.petric@example.hr', '+33612345678', '+33123456789', 'Korisnička podrška', 21),
(7, 'ivana.zupan@example.si', '+385989541338', '+38511234567', 'Marketing', 30),
(8, 'giulia.ivanovic@example.rs', '+393471234567', '+39123456782', 'Odnosi s javnošću', 17),
(9, 'elena.krajnc@example.si', '+393491234567', '+39123456780', 'Logistika', 19),
(10, 'boris.jakovljevic@example.ba', '+385989541328', '+38511234568', 'Nabava', 20),
(11, 'leo.pavlovic@example.hr', '+33623456789', '+33123456783', 'Administracija', 12),
(12, 'ana.peric@example.rs', '+385989541326', '+38511234567', 'Istraživanje i razvoj', 16),
(13, 'raphael.knez@example.si', '+393921234567', '+39123456789', 'Kvaliteta', 3),
(14, 'nina.stojanovic@example.ba', '+4915112345678', '+493012345672', 'Proizvodnja', 6),
(15, 'julie.kovac@example.si', '+33123456782', '+33123456782', 'Uprava', 7),
(16, 'marko.kovacevic@example.hr', '+385989541324', '+38511234567', 'Glavni kontakt', 11),
(17, 'claire.vidovic@example.si', '+33633456789', '+33123456784', 'Podrška', 4),
(18, 'louis.markovic@example.rs', '+33612456789', '+33123456781', 'Prodaja', 15),
(19, 'ivana.milosevic@example.ba', '+385989541322', '+38511234567', 'Računovodstvo', 26),
(20, 'matej.kralj@example.si', '+385989541320', '+38511234567', 'Tehnička podrška', 28),
(21, 'sara.horvat@example.hr', '+385989541318', '+38511234569', 'Korisnička podrška', 23),
(22, 'lena.jankovic@example.rs', '+385989541316', '+38511234568', 'Marketing', 8),
(23, 'tim.stojanovic@example.si', '+33614567890', '+33123456789', 'Odnosi s javnošću', 9),
(24, 'giulia.petric@example.si', '+393191234567', '+39123456782', 'Logistika', 10),
(25, 'boris.nikolic@example.rs', '+385989541310', '+38511234568', 'Nabava', 18),
(26, 'leo.stojanovic@example.ba', '+33614789523', '+33123456783', 'Administracija', 1),
(27, 'ana.kovacevic@example.rs', '+385989541304', '+38511234567', 'Istraživanje i razvoj', 2),
(28, 'raphael.milosevic@example.si', '+393921234567', '+39123456789', 'Kvaliteta', 13),
(29, 'nina.zupan@example.ba', '+4915112345678', '+493012345672', 'Proizvodnja', 24),
(30, 'julie.kralj@example.si', '+33611234567', '+33123456782', 'Uprava', 29);

INSERT INTO vozilo VALUES -- Mirela
(1, '2018', 'ZG1234AB', 'Električno'),
(2, '2019', 'ST5678CD', 'Hibridno'),
(3, '2017', 'ZG9012EF', 'Benzin'),
(4, '2020', 'RI3456GH', 'Diesel'),
(5, '2018', 'OS7890IJ', 'Električno'),
(6, '2019', 'PU2345KL', 'Benzin'),
(7, '2023', 'DU6789MN', 'Hibridno'),
(8, '2020', 'KA1234OP', 'Diesel'),
(9, '2024', 'ZG5678QR', 'Električno'),
(10, '2022', 'ST9012RS', 'Benzin'),
(11, '2021', 'ZG3456TU', 'Hibridno'),
(12, '2020', 'RI7890VW', 'Diesel'),
(13, '2018', 'OS1234XY', 'Električno'),
(14, '2019', 'PU5678ZA', 'Benzin'),
(15, '2010', 'DU9012BC', 'Hibridno'),
(16, '2020', 'KA3456DE', 'Diesel'),
(17, '2018', 'ZG7890FG', 'Električno'),
(18, '2023', 'ST1234HI', 'Benzin'),
(19, '2017', 'ZG5678JK', 'Hibridno'),
(20, '2020', 'RI9012LM', 'Diesel'),
(21, '2015', 'OS3456NO', 'Električno'),
(22, '2019', 'PU7890PQ', 'Benzin'),
(23, '2017', 'DU1234RS', 'Hibridno'),
(24, '2020', 'KA5678TU', 'Diesel'),
(25, '2018', 'ZG9012VW', 'Električno'),
(26, '2019', 'ST3456XY', 'Benzin'),
(27, '2017', 'ZG7890ZA', 'Hibridno'),
(28, '2022', 'RI1234BC', 'Diesel'),
(29, '2018', 'OS5678DE', 'Električno'),
(30, '2019', 'PU9012FG', 'Benzin');

INSERT INTO najam_vozila VALUES -- Mirela
(1, 20, 14, 9, 17, '2024-05-01', '2024-05-10', 'Aktivan', 1000.00, 1200.00),
(2, 3, 10, 25, 5, '2024-05-02', '2024-05-11', 'Aktivan', 900.00, 1100.00),
(3, 12, 1, 25, 23, '2024-05-03', '2024-05-12', 'Aktivan', 1100.00, 1300.00),
(4, 27, 28, 2, 13, '2024-05-04', '2024-05-13', 'Neaktivan', 950.00, 1150.00),
(5, 8, 21, 16, 29, '2024-05-05', '2024-05-14', 'Neaktivan', 1050.00, 1250.00),
(6, 26, 6, 12, 30, '2024-05-06', '2024-05-15', 'Aktivan', 980.00, 1180.00),
(7, 15, 5, 19, 21, '2024-05-07', '2024-05-16', 'Neaktivan', 1150.00, 1350.00),
(8, 7, 22, 7, 8, '2024-05-08', '2024-05-17', 'Aktivan', 1020.00, 1220.00),
(9, 18, 29, 7, 14, '2024-05-09', '2024-05-10', 'Aktivan', 1080.00, 1280.00),
(10, 9, 4, 24, 28, '2024-05-10', '2024-05-12', 'Aktivan', 1005.00, 1205.00),
(11, 11, 7, 23, 24, '2024-05-11', '2024-05-12', 'Aktivan', 950.00, 1150.00),
(12, 28, 17, 11, 3, '2024-05-12', '2024-05-14', 'Aktivan', 970.00, 1170.00),
(13, 1, 2, 30, 4, '2024-05-13', '2024-05-22', 'Aktivan', 990.00, 1190.00),
(14, 23, 7, 14, 15, '2024-05-14', '2024-05-16', 'Aktivan', 1025.00, 1225.00),
(15, 5, 8, 7, 22, '2024-05-15', '2024-05-18', 'Aktivan', 975.00, 1175.00),
(16, 13, 15, 1, 22, '2024-05-16', '2024-05-20', 'Aktivan', 1030.00, 1230.00),
(17, 19, 7, 5, 18, '2024-05-17', '2024-05-20', 'Neaktivan', 1015.00, 1215.00),
(18, 6, 30, 28, 2, '2024-05-18', '2024-05-19', 'Aktivan', 980.00, 1180.00),
(19, 25, 19, 6, 22, '2024-05-19', '2024-05-28', 'Aktivan', 1100.00, 1300.00),
(20, 22, 9, 26, 19, '2024-05-20', '2024-05-29', 'Aktivan', 960.00, 1160.00),
(21, 4, 24, 27, 7, '2024-05-21', '2024-05-30', 'Aktivan', 1000.00, 1200.00),
(22, 14, 18, 10, 7, '2024-05-22', '2024-05-31', 'Aktivan', 1035.00, 1235.00),
(23, 30, 16, 13, 20, '2024-05-23', '2024-06-01', 'Aktivan', 990.00, 1190.00),
(24, 10, 11, 8, 7, '2024-05-24', '2024-06-02', 'Aktivan', 1020.00, 1220.00),
(25, 17, 13, 15, 1, '2024-05-25', '2024-06-03', 'Aktivan', 980.00, 1180.00),
(26, 24, 27, 9, 11, '2024-05-26', '2024-06-04', 'Aktivan', 1005.00, 1205.00),
(27, 2, 26, 4, 27, '2024-05-27', '2024-06-05', 'Neaktivan', 1050.00, 1250.00),
(28, 29, 3, 12, 30, '2024-05-28', '2024-06-06', 'Neaktivan', 970.00, 1170.00),
(29, 21, 20, 17, 9, '2024-05-29', '2024-06-07', 'Aktivan', 1025.00, 1225.00),
(30, 16, 22, 2, 6, '2024-05-30', '2024-06-08', 'Aktivan', 1000.00, 1200.00);

INSERT INTO serija_auto_kamion (id, ime, proizvodac, najveca_brzina, konjska_snaga, tip_mjenjaca, broj_vrata) VALUES -- Vedrana
(1, 'Volvo FH', 'Volvo', 90, 500, 'Ručni', 2),
(2, 'Scania R-series', 'Scania', 95, 540, 'Automatski', 2),
(3, 'MAN TGX', 'MAN', 92, 480, 'Ručni', 2),
(4, 'Mercedes-Benz Actros', 'Mercedes-Benz', 85, 450, 'Automatski', 2),
(5, 'Iveco Stralis', 'Iveco', 88, 480, 'Ručni', 2),
(6, 'Renault T', 'Renault', 90, 520, 'Automatski', 2),
(7, 'DAF XF', 'DAF', 85, 480, 'Ručni', 2),
(8, 'Volvo FMX', 'Volvo', 80, 460, 'Ručni', 2),
(9, 'Scania P-series', 'Scania', 85, 480, 'Automatski', 2),
(10, 'MAN TGL', 'MAN', 75, 320, 'Ručni', 2),
(11, 'Mercedes-Benz Atego', 'Mercedes-Benz', 80, 300, 'Automatski', 2),
(12, 'Iveco Eurocargo', 'Iveco', 78, 320, 'Ručni', 2),
(13, 'Renault D', 'Renault', 75, 350, 'Automatski', 2),
(14, 'DAF LF', 'DAF', 70, 300, 'Ručni', 2),
(15, 'Volvo FL', 'Volvo', 70, 320, 'Ručni', 2),
(16, 'Scania G-series', 'Scania', 75, 340, 'Automatski', 2),
(17, 'MAN TGS', 'MAN', 78, 360, 'Ručni', 2),
(18, 'Mercedes-Benz Econic', 'Mercedes-Benz', 65, 240, 'Automatski', 2),
(19, 'Iveco Daily', 'Iveco', 70, 220, 'Ručni', 2),
(20, 'Renault K', 'Renault', 72, 250, 'Automatski', 2),
(21, 'DAF CF', 'DAF', 68, 280, 'Ručni', 2),
(22, 'Volvo FE', 'Volvo', 68, 260, 'Ručni', 2),
(23, 'Scania L-series', 'Scania', 70, 300, 'Automatski', 2),
(24, 'MAN TGM', 'MAN', 68, 280, 'Ručni', 2),
(25, 'Mercedes-Benz Arocs', 'Mercedes-Benz', 65, 300, 'Ručni', 2),
(26, 'Iveco Trakker', 'Iveco', 62, 320, 'Ručni', 2),
(27, 'Renault C', 'Renault', 65, 280, 'Ručni', 2),
(28, 'DAF XF', 'DAF', 68, 300, 'Automatski', 2),
(29, 'Volvo FH16', 'Volvo', 100, 750, 'Ručni', 2),
(30, 'Scania S-series', 'Scania', 105, 770, 'Automatski', 2);

INSERT INTO automobil (id, id_serija_auto_kamion, id_vozilo, duljina) VALUES -- Vedrana
(1, 3, 16, 5.8),
(2, 8, 24, 6.2),
(3, 12, 11, 7.0),
(4, 5, 7, 6.5),
(5, 10, 19, 5.9),
(6, 15, 23, 6.8),
(7, 2, 29, 5.6),
(8, 6, 2, 6.3),
(9, 11, 14, 5.7),
(10, 1, 20, 6.1),
(11, 14, 9, 5.5),
(12, 9, 21, 6.4),
(13, 4, 25, 7.2),
(14, 7, 13, 5.4),
(15, 13, 28, 6.6),
(16, 30, 18, 5.3),
(17, 27, 1, 6.0),
(18, 24, 27, 6.7),
(19, 17, 4, 5.2),
(20, 22, 22, 5.9),
(21, 16, 30, 6.8),
(22, 23, 5, 5.6),
(23, 19, 17, 6.3),
(24, 26, 26, 5.5),
(25, 21, 8, 6.2),
(26, 28, 3, 7.0),
(27, 25, 15, 5.8),
(28, 20, 12, 6.1),
(29, 29, 10, 7.2),
(30, 18, 6, 5.4);

INSERT INTO serija_motocikl (id, ime, proizvodac, najveca_brzina, konjska_snaga, broj_sjedala) VALUES -- Vedrana
(1, 'Ninja 300', 'Kawasaki', 190, 39, 2),
(2, 'MT-07', 'Yamaha', 210, 74, 2),
(3, 'CBR1000RR', 'Honda', 299, 190, 1),
(4, 'S1000RR', 'BMW', 305, 207, 1),
(5, 'Panigale V4', 'Ducati', 291, 214, 1),
(6, 'GSX-R1000', 'Suzuki', 299, 202, 1),
(7, 'R1', 'Yamaha', 299, 200, 1),
(8, 'ZX-10R', 'Kawasaki', 299, 200, 1),
(9, 'CBR600RR', 'Honda', 256, 118, 1),
(10, 'R1250GS', 'BMW', 200, 136, 2),
(11, 'Scrambler', 'Ducati', 193, 73, 1),
(12, 'Hayabusa', 'Suzuki', 312, 197, 2),
(13, 'GSX-S750', 'Suzuki', 209, 114, 1),
(14, 'Ninja ZX-6R', 'Kawasaki', 262, 128, 1),
(15, 'YZF-R6', 'Yamaha', 257, 118, 1),
(16, 'CB650R', 'Honda', 225, 95, 1),
(17, 'F900R', 'BMW', 240, 105, 1),
(18, 'Monster', 'Ducati', 248, 109, 1),
(19, 'SV650', 'Suzuki', 201, 75, 2),
(20, 'Ninja 650', 'Kawasaki', 220, 68, 2),
(21, 'MT-09', 'Yamaha', 235, 115, 1),
(22, 'Africa Twin', 'Honda', 212, 101, 2),
(23, 'R1250RT', 'BMW', 208, 136, 2),
(24, 'Multistrada', 'Ducati', 290, 158, 2),
(25, 'V-Strom 650', 'Suzuki', 202, 71, 2),
(26, 'Versys 650', 'Kawasaki', 195, 68, 2),
(27, 'Tracer 900', 'Yamaha', 235, 115, 2),
(28, 'CB500F', 'Honda', 180, 47, 1),
(29, 'F750GS', 'BMW', 190, 77, 1),
(30, 'Scrambler Desert Sled', 'Ducati', 193, 73, 1);

INSERT INTO motocikl (id, id_serija_motocikl, id_vozilo, duljina) VALUES -- Vedrana
(1, 18, 23, 210.00),
(2, 21, 7, 215.00),
(3, 6, 28, 200.00),
(4, 3, 5, 210.00),
(5, 16, 15, 195.00),
(6, 12, 11, 220.00),
(7, 10, 4, 225.00),
(8, 28, 24, 215.00),
(9, 20, 3, 205.00),
(10, 14, 16, 200.00),
(11, 23, 12, 230.00),
(12, 26, 29, 220.00),
(13, 17, 10, 215.00),
(14, 27, 21, 225.00),
(15, 9, 2, 210.00),
(16, 8, 17, 200.00),
(17, 25, 20, 215.00),
(18, 11, 22, 230.00),
(19, 5, 6, 195.00),
(20, 1, 25, 205.00),
(21, 15, 19, 220.00),
(22, 19, 30, 215.00),
(23, 30, 18, 230.00),
(24, 4, 13, 200.00),
(25, 2, 8, 210.00),
(26, 13, 27, 225.00),
(27, 22, 26, 220.00),
(28, 7, 14, 215.00),
(29, 24, 9, 205.00),
(30, 29, 1, 210.00);

INSERT INTO kamion (id, id_serija_auto_kamion, id_vozilo, duljina, visina, nosivost) VALUES -- Vedrana
(1, 20, 7, 8000.00, 3500.00, 15000.00),
(2, 5, 28, 9500.00, 4000.00, 20000.00),
(3, 11, 11, 7000.00, 3200.00, 12000.00),
(4, 15, 5, 8500.00, 3800.00, 18000.00),
(5, 25, 15, 9000.00, 3900.00, 22000.00),
(6, 27, 30, 10000.00, 4100.00, 25000.00),
(7, 17, 4, 8000.00, 3500.00, 15000.00),
(8, 9, 23, 7500.00, 3300.00, 13000.00),
(9, 18, 3, 9200.00, 3950.00, 19000.00),
(10, 3, 16, 8700.00, 3800.00, 21000.00),
(11, 29, 12, 9300.00, 4000.00, 23000.00),
(12, 22, 29, 9700.00, 4200.00, 26000.00),
(13, 7, 10, 8200.00, 3600.00, 16000.00),
(14, 2, 21, 8900.00, 3800.00, 20000.00),
(15, 21, 2, 7800.00, 3450.00, 14000.00),
(16, 12, 17, 8600.00, 3750.00, 17000.00),
(17, 28, 20, 9200.00, 3950.00, 21000.00),
(18, 14, 22, 9400.00, 4000.00, 24000.00),
(19, 26, 6, 9600.00, 4100.00, 27000.00),
(20, 10, 25, 9900.00, 4200.00, 28000.00),
(21, 24, 19, 8100.00, 3600.00, 17000.00),
(22, 8, 1, 8800.00, 3850.00, 18000.00),
(23, 30, 26, 9100.00, 3950.00, 22000.00),
(24, 6, 14, 8500.00, 3700.00, 16000.00),
(25, 19, 9, 8900.00, 3850.00, 19000.00),
(26, 1, 24, 9300.00, 4000.00, 23000.00),
(27, 16, 8, 9500.00, 4100.00, 25000.00),
(28, 13, 27, 9800.00, 4200.00, 27000.00),
(29, 23, 26, 8200.00, 3600.00, 16000.00),
(30, 4, 18, 8700.00, 3800.00, 20000.00);

INSERT INTO slika_automobila (id_automobil, slika, pozicija) VALUES -- Marinela
(1, 'http://tvrtka-za-najam-vozila.com/slike/automobil1.jpg', 'prednja'),
(2, 'http://tvrtka-za-najam-vozila.com/slike/automobil2.jpg', 'bočna'),
(3, 'http://tvrtka-za-najam-vozila.com/slike/automobil3.jpg', 'stražnja'),
(4, 'http://tvrtka-za-najam-vozila.com/slike/automobil4.jpg', 'krovna'),
(5, 'http://tvrtka-za-najam-vozila.com/slike/automobil5.jpg', 'unutrašnja'),
(6, 'http://tvrtka-za-najam-vozila.com/slike/automobil6.jpg', 'stražnja'),
(7, 'http://tvrtka-za-najam-vozila.com/slike/automobil7.jpg', 'stražnja'),
(8, 'http://tvrtka-za-najam-vozila.com/slike/automobil8.jpg', 'stražnja'),
(9, 'http://tvrtka-za-najam-vozila.com/slike/automobil9.jpg', 'stražnja'),
(10, 'http://tvrtka-za-najam-vozila.com/slike/automobil10.jpg', 'bočna'),
(11, 'http://tvrtka-za-najam-vozila.com/slike/automobil11.jpg', 'bočna'),
(12, 'http://tvrtka-za-najam-vozila.com/slike/automobil12.jpg', 'bočna'),
(13, 'http://tvrtka-za-najam-vozila.com/slike/automobil13.jpg', 'stražnja'),
(14, 'http://tvrtka-za-najam-vozila.com/slike/automobil14.jpg', 'stražnja'),
(15, 'http://tvrtka-za-najam-vozila.com/slike/automobil15.jpg', 'bočna'),
(16, 'http://tvrtka-za-najam-vozila.com/slike/automobil16.jpg', 'unutrašnjost'),
(17, 'http://tvrtka-za-najam-vozila.com/slike/automobil17.jpg', 'prednja'),
(18, 'http://tvrtka-za-najam-vozila.com/slike/automobil18.jpg', 'stražnja'),
(19, 'http://tvrtka-za-najam-vozila.com/slike/automobil19.jpg', 'unutrašnjost'),
(20, 'http://tvrtka-za-najam-vozila.com/slike/automobil20.jpg', 'prednja'),
(21, 'http://tvrtka-za-najam-vozila.com/slike/automobil21.jpg', 'prednja'),
(22, 'http://tvrtka-za-najam-vozila.com/slike/automobil22.jpg', 'stražnja'),
(23, 'http://tvrtka-za-najam-vozila.com/slike/automobil23.jpg', 'bočna'),
(24, 'http://tvrtka-za-najam-vozila.com/slike/automobil24.jpg', 'prednja'),
(25, 'http://tvrtka-za-najam-vozila.com/slike/automobil25.jpg', 'bočna'),
(26, 'http://tvrtka-za-najam-vozila.com/slike/automobil26.jpg', 'krovna'),
(27, 'http://tvrtka-za-najam-vozila.com/slike/automobil27.jpg', 'bočna'),
(28, 'http://tvrtka-za-najam-vozila.com/slike/automobil28.jpg', 'unutrašnjost'),
(29, 'http://tvrtka-za-najam-vozila.com/slike/automobil29.jpg', 'bočna'),
(30, 'http://tvrtka-za-najam-vozila.com/slike/automobil30.jpg', 'bočna');

INSERT INTO slika_motora (id_motocikl, slika, pozicija) VALUES -- Marinela
(1, 'http://tvrtka-za-najam-vozila.com/slike/motocikl1.jpg', 'prednja'),
(2, 'http://tvrtka-za-najam-vozila.com/slike/motocikl2.jpg', 'bočna'),
(3, 'http://tvrtka-za-najam-vozila.com/slike/motocikl3.jpg', 'stražnja'),
(4, 'http://tvrtka-za-najam-vozila.com/slike/motocikl4.jpg', 'stražnja'),
(5, 'http://tvrtka-za-najam-vozila.com/slike/motocikl5.jpg', 'bočna'),
(6, 'http://tvrtka-za-najam-vozila.com/slike/motocikl6.jpg', 'prednja'),
(7, 'http://tvrtka-za-najam-vozila.com/slike/motocikl7.jpg', 'bočna'),
(8, 'http://tvrtka-za-najam-vozila.com/slike/motocikl8.jpg', 'prednja'),
(9, 'http://tvrtka-za-najam-vozila.com/slike/motocikl9.jpg', 'stražnja'),
(10, 'http://tvrtka-za-najam-vozila.com/slike/motocikl10.jpg', 'stražnja'),
(11, 'http://tvrtka-za-najam-vozila.com/slike/motocikl11.jpg', 'prednja'),
(12, 'http://tvrtka-za-najam-vozila.com/slike/motocikl12.jpg', 'bočna'),
(13, 'http://tvrtka-za-najam-vozila.com/slike/motocikl13.jpg', 'stražnja'),
(14, 'http://tvrtka-za-najam-vozila.com/slike/motocikl14.jpg', 'stražnja'),
(15, 'http://tvrtka-za-najam-vozila.com/slike/motocikl15.jpg', 'bočna'),
(16, 'http://tvrtka-za-najam-vozila.com/slike/motocikl16.jpg', 'prednja'),
(17, 'http://tvrtka-za-najam-vozila.com/slike/motocikl17.jpg', 'bočna'),
(18, 'http://tvrtka-za-najam-vozila.com/slike/motocikl18.jpg', 'stražnja'),
(19, 'http://tvrtka-za-najam-vozila.com/slike/motocikl19.jpg', 'stražnja'),
(20, 'http://tvrtka-za-najam-vozila.com/slike/motocikl20.jpg', 'bočna'),
(21, 'http://tvrtka-za-najam-vozila.com/slike/motocikl21.jpg', 'prednja'),
(22, 'http://tvrtka-za-najam-vozila.com/slike/motocikl22.jpg', 'bočna'),
(23, 'http://tvrtka-za-najam-vozila.com/slike/motocikl23.jpg', 'stražnja'),
(24, 'http://tvrtka-za-najam-vozila.com/slike/motocikl24.jpg', 'stražnja'),
(25, 'http://tvrtka-za-najam-vozila.com/slike/motocikl25.jpg', 'bočna'),
(26, 'http://tvrtka-za-najam-vozila.com/slike/motocikl26.jpg', 'prednja'),
(27, 'http://tvrtka-za-najam-vozila.com/slike/motocikl27.jpg', 'bočna'),
(28, 'http://tvrtka-za-najam-vozila.com/slike/motocikl28.jpg', 'prednja'),
(29, 'http://tvrtka-za-najam-vozila.com/slike/motocikl29.jpg', 'stražnja'),
(30, 'http://tvrtka-za-najam-vozila.com/slike/motocikl30.jpg', 'stražnja');

INSERT INTO slika_kamiona (id_kamion, slika, pozicija) VALUES -- Marinela
(1, 'http://tvrtka-za-najam-vozila.com/slike/kamion1.jpg', 'prednja'),
(2, 'http://tvrtka-za-najam-vozila.com/slike/kamion2.jpg', 'bočna'),
(3, 'http://tvrtka-za-najam-vozila.com/slike/kamion3.jpg', 'stražnja'),
(4, 'http://tvrtka-za-najam-vozila.com/slike/kamion4.jpg', 'krovna'),
(5, 'http://tvrtka-za-najam-vozila.com/slike/kamion5.jpg', 'unutrašnja'),
(6, 'http://tvrtka-za-najam-vozila.com/slike/kamion6.jpg', 'stražnja'),
(7, 'http://tvrtka-za-najam-vozila.com/slike/kamion7.jpg', 'bočna'),
(8, 'http://tvrtka-za-najam-vozila.com/slike/kamion8.jpg', 'stražnja'),
(9, 'http://tvrtka-za-najam-vozila.com/slike/kamion9.jpg', 'stražnja'),
(10, 'http://tvrtka-za-najam-vozila.com/slike/kamion10.jpg', 'bočna'),
(11, 'http://tvrtka-za-najam-vozila.com/slike/kamion11.jpg', 'bočna'),
(12, 'http://tvrtka-za-najam-vozila.com/slike/kamion12.jpg', 'prednja'),
(13, 'http://tvrtka-za-najam-vozila.com/slike/kamion13.jpg', 'stražnja'),
(14, 'http://tvrtka-za-najam-vozila.com/slike/kamion14.jpg', 'stražnja'),
(15, 'http://tvrtka-za-najam-vozila.com/slike/kamion15.jpg', 'bočna'),
(16, 'http://tvrtka-za-najam-vozila.com/slike/kamion16.jpg', 'bočna'),
(17, 'http://tvrtka-za-najam-vozila.com/slike/kamion17.jpg', 'prednja'),
(18, 'http://tvrtka-za-najam-vozila.com/slike/kamion18.jpg', 'stražnja'),
(19, 'http://tvrtka-za-najam-vozila.com/slike/kamion19.jpg', 'bočna'),
(20, 'http://tvrtka-za-najam-vozila.com/slike/kamion20.jpg', 'prednja'),
(21, 'http://tvrtka-za-najam-vozila.com/slike/kamion21.jpg', 'prednja'),
(22, 'http://tvrtka-za-najam-vozila.com/slike/kamion22.jpg', 'stražnja'),
(23, 'http://tvrtka-za-najam-vozila.com/slike/kamion23.jpg', 'bočna'),
(24, 'http://tvrtka-za-najam-vozila.com/slike/kamion24.jpg', 'bočna'),
(25, 'http://tvrtka-za-najam-vozila.com/slike/kamion25.jpg', 'bočna'),
(26, 'http://tvrtka-za-najam-vozila.com/slike/kamion26.jpg', 'prednja'),
(27, 'http://tvrtka-za-najam-vozila.com/slike/kamion27.jpg', 'bočna'),
(28, 'http://tvrtka-za-najam-vozila.com/slike/kamion28.jpg', 'stražnja'),
(29, 'http://tvrtka-za-najam-vozila.com/slike/kamion29.jpg', 'prednja'),
(30, 'http://tvrtka-za-najam-vozila.com/slike/kamion30.jpg', 'bočna');

INSERT INTO osiguranje (id, id_osiguravajuca_kuca, id_vozilo, id_transakcija, datum_pocetka, datum_zavrsetka, tip_osiguranja) VALUES -- Vedrana
(1, 22, 18, 13, STR_TO_DATE('2023-05-03', '%Y-%m-%d'), STR_TO_DATE('2024-05-02', '%Y-%m-%d'), 'Osnovno'),
(2, 5, 26, 19, STR_TO_DATE('2023-06-05', '%Y-%m-%d'), STR_TO_DATE('2024-06-04', '%Y-%m-%d'), 'Premium'),
(3, 11, 3, 4, STR_TO_DATE('2023-07-07', '%Y-%m-%d'), STR_TO_DATE('2024-07-06', '%Y-%m-%d'), 'Standardno'),
(4, 15, 9, 2, STR_TO_DATE('2023-08-09', '%Y-%m-%d'), STR_TO_DATE('2024-08-08', '%Y-%m-%d'), 'Osnovno'),
(5, 25, 15, 27, STR_TO_DATE('2023-09-11', '%Y-%m-%d'), STR_TO_DATE('2024-09-10', '%Y-%m-%d'), 'Premium'),
(6, 27, 30, 5, STR_TO_DATE('2023-10-13', '%Y-%m-%d'), STR_TO_DATE('2024-10-12', '%Y-%m-%d'), 'Standardno'),
(7, 17, 4, 21, STR_TO_DATE('2023-11-15', '%Y-%m-%d'), STR_TO_DATE('2024-11-14', '%Y-%m-%d'), 'Osnovno'),
(8, 9, 23, 12, STR_TO_DATE('2023-12-17', '%Y-%m-%d'), STR_TO_DATE('2024-12-16', '%Y-%m-%d'), 'Premium'),
(9, 18, 3, 9, STR_TO_DATE('2024-01-19', '%Y-%m-%d'), STR_TO_DATE('2025-01-18', '%Y-%m-%d'), 'Standardno'),
(10, 3, 16, 6, STR_TO_DATE('2024-02-21', '%Y-%m-%d'), STR_TO_DATE('2025-02-20', '%Y-%m-%d'), 'Osnovno'),
(11, 29, 12, 8, STR_TO_DATE('2024-03-23', '%Y-%m-%d'), STR_TO_DATE('2025-03-22', '%Y-%m-%d'), 'Premium'),
(12, 22, 29, 25, STR_TO_DATE('2024-04-25', '%Y-%m-%d'), STR_TO_DATE('2025-04-24', '%Y-%m-%d'), 'Standardno'),
(13, 7, 10, 11, STR_TO_DATE('2024-05-27', '%Y-%m-%d'), STR_TO_DATE('2025-05-26', '%Y-%m-%d'), 'Osnovno'),
(14, 2, 21, 28, STR_TO_DATE('2024-06-29', '%Y-%m-%d'), STR_TO_DATE('2025-06-28', '%Y-%m-%d'), 'Premium'),
(15, 21, 2, 15, STR_TO_DATE('2024-07-31', '%Y-%m-%d'), STR_TO_DATE('2025-07-30', '%Y-%m-%d'), 'Standardno'),
(16, 12, 17, 7, STR_TO_DATE('2024-08-02', '%Y-%m-%d'), STR_TO_DATE('2025-08-01', '%Y-%m-%d'), 'Osnovno'),
(17, 28, 20, 30, STR_TO_DATE('2024-09-04', '%Y-%m-%d'), STR_TO_DATE('2025-09-03', '%Y-%m-%d'), 'Premium'),
(18, 14, 22, 20, STR_TO_DATE('2024-10-06', '%Y-%m-%d'), STR_TO_DATE('2025-10-05', '%Y-%m-%d'), 'Standardno'),
(19, 26, 6, 22, STR_TO_DATE('2024-11-08', '%Y-%m-%d'), STR_TO_DATE('2025-11-07', '%Y-%m-%d'), 'Osnovno'),
(20, 10, 25, 14, STR_TO_DATE('2024-12-10', '%Y-%m-%d'), STR_TO_DATE('2025-12-09', '%Y-%m-%d'), 'Premium'),
(21, 24, 19, 1, STR_TO_DATE('2025-01-12', '%Y-%m-%d'), STR_TO_DATE('2026-01-11', '%Y-%m-%d'), 'Standardno'),
(22, 8, 1, 29, STR_TO_DATE('2025-02-14', '%Y-%m-%d'), STR_TO_DATE('2026-02-13', '%Y-%m-%d'), 'Osnovno'),
(23, 30, 26, 26, STR_TO_DATE('2025-03-16', '%Y-%m-%d'), STR_TO_DATE('2026-03-15', '%Y-%m-%d'), 'Premium'),
(24, 6, 14, 1, STR_TO_DATE('2025-04-18', '%Y-%m-%d'), STR_TO_DATE('2026-04-17', '%Y-%m-%d'), 'Standardno'),
(25, 19, 9, 23, STR_TO_DATE('2025-05-20', '%Y-%m-%d'), STR_TO_DATE('2026-05-19', '%Y-%m-%d'), 'Osnovno'),
(26, 1, 24, 17, STR_TO_DATE('2025-06-22', '%Y-%m-%d'), STR_TO_DATE('2026-06-21', '%Y-%m-%d'), 'Premium'),
(27, 16, 8, 24, STR_TO_DATE('2025-07-26', '%Y-%m-%d'), STR_TO_DATE('2026-07-25', '%Y-%m-%d'), 'Standardno'),
(28, 13, 27, 10, STR_TO_DATE('2025-08-28', '%Y-%m-%d'), STR_TO_DATE('2026-08-27', '%Y-%m-%d'), 'Osnovno'),
(29, 23, 26, 3, STR_TO_DATE('2025-09-29', '%Y-%m-%d'), STR_TO_DATE('2026-09-28', '%Y-%m-%d'), 'Premium'),
(30, 4, 18, 18, STR_TO_DATE('2025-10-31', '%Y-%m-%d'), STR_TO_DATE('2026-10-30', '%Y-%m-%d'), 'Standardno');

INSERT INTO steta (id, tip, opis) VALUES -- Vedrana
(1, 'Oštećenje', 'Oštećenje lijevog retrovizora'),
(2, 'Krađa', 'Ukraden radio iz vozila'),
(3, 'Oštećenje', 'Oštećenje prednjeg branika'),
(4, 'Nesreća', 'Zamjena stražnjeg branika nakon sudara'),
(5, 'Krađa', 'Ukraden laptop iz vozila'),
(6, 'Oštećenje', 'Oštećenje desnog prednjeg blatobrana'),
(7, 'Nesreća', 'Oštećenje vrata nakon parkiranja'),
(8, 'Oštećenje', 'Oštećenje bočnog retrovizora'),
(9, 'Krađa', 'Ukradena navigacija iz vozila'),
(10, 'Oštećenje', 'Oštećenje lijevog bočnog stakla'),
(11, 'Krađa', 'Ukradena registracijska pločica'),
(12, 'Oštećenje', 'Oštećenje desnog bočnog stakla'),
(13, 'Nesreća', 'Oštećenje haube nakon sudara'),
(14, 'Oštećenje', 'Oštećenje lijevog prednjeg blatobrana'),
(15, 'Krađa', 'Ukradena antena s vozila'),
(16, 'Oštećenje', 'Oštećenje desnog retrovizora'),
(17, 'Krađa', 'Ukraden volan iz vozila'),
(18, 'Oštećenje', 'Oštećenje desnog bočnog retrovizora'),
(19, 'Nesreća', 'Oštećenje stražnjeg stakla nakon sudara'),
(20, 'Oštećenje', 'Oštećenje desnog bočnog retrovizora'),
(21, 'Krađa', 'Ukraden CD player iz vozila'),
(22, 'Oštećenje', 'Oštećenje desnog bočnog stakla'),
(23, 'Nesreća', 'Oštećenje stražnjeg branika nakon sudara'),
(24, 'Oštećenje', 'Oštećenje desnog bočnog retrovizora'),
(25, 'Krađa', 'Ukradena oprema za prvu pomoć iz vozila'),
(26, 'Oštećenje', 'Oštećenje desnog prednjeg blatobrana'),
(27, 'Nesreća', 'Oštećenje lijevog prednjeg blatobrana nakon sudara'),
(28, 'Oštećenje', 'Oštećenje lijevog bočnog stakla'),
(29, 'Krađa', 'Ukraden mobitel iz vozila'),
(30, 'Oštećenje', 'Oštećenje desnog prednjeg blatobrana');

INSERT INTO naknada_stete (id, datum_pocetka, datum_zavrsetka, id_transakcija, id_osiguranje, id_steta) VALUES -- Vedrana
(1, STR_TO_DATE('2023-08-01', '%Y-%m-%d'), STR_TO_DATE('2024-02-01', '%Y-%m-%d'), 12, 3, 21),
(2, STR_TO_DATE('2023-09-15', '%Y-%m-%d'), STR_TO_DATE('2024-03-15', '%Y-%m-%d'), 7, 18, 14),
(3, STR_TO_DATE('2023-10-20', '%Y-%m-%d'), STR_TO_DATE('2024-04-20', '%Y-%m-%d'), 20, 24, 5),
(4, STR_TO_DATE('2023-11-05', '%Y-%m-%d'), STR_TO_DATE('2024-05-05', '%Y-%m-%d'), 4, 16, 27),
(5, STR_TO_DATE('2023-12-10', '%Y-%m-%d'), STR_TO_DATE('2024-06-10', '%Y-%m-%d'), 25, 20, 11),
(6, STR_TO_DATE('2024-01-15', '%Y-%m-%d'), STR_TO_DATE('2024-07-15', '%Y-%m-%d'), 29, 8, 1),
(7, STR_TO_DATE('2024-02-20', '%Y-%m-%d'), STR_TO_DATE('2024-08-20', '%Y-%m-%d'), 17, 30, 15),
(8, STR_TO_DATE('2024-03-05', '%Y-%m-%d'), STR_TO_DATE('2024-09-05', '%Y-%m-%d'), 23, 14, 22),
(9, STR_TO_DATE('2024-04-10', '%Y-%m-%d'), STR_TO_DATE('2024-10-10', '%Y-%m-%d'), 5, 22, 9),
(10, STR_TO_DATE('2024-05-15', '%Y-%m-%d'), STR_TO_DATE('2024-11-15', '%Y-%m-%d'), 21, 26, 18),
(11, STR_TO_DATE('2024-06-20', '%Y-%m-%d'), STR_TO_DATE('2024-12-20', '%Y-%m-%d'), 1, 10, 26),
(12, STR_TO_DATE('2024-07-25', '%Y-%m-%d'), STR_TO_DATE('2025-01-25', '%Y-%m-%d'), 19, 2, 8),
(13, STR_TO_DATE('2024-08-30', '%Y-%m-%d'), STR_TO_DATE('2025-02-28', '%Y-%m-%d'), 11, 6, 13),
(14, STR_TO_DATE('2024-10-05', '%Y-%m-%d'), STR_TO_DATE('2025-04-05', '%Y-%m-%d'), 30, 28, 16),
(15, STR_TO_DATE('2024-11-10', '%Y-%m-%d'), STR_TO_DATE('2025-05-10', '%Y-%m-%d'), 15, 4, 23),
(16, STR_TO_DATE('2024-12-15', '%Y-%m-%d'), STR_TO_DATE('2025-06-15', '%Y-%m-%d'), 28, 12, 6),
(17, STR_TO_DATE('2025-01-20', '%Y-%m-%d'), STR_TO_DATE('2025-07-20', '%Y-%m-%d'), 13, 16, 29),
(18, STR_TO_DATE('2025-02-25', '%Y-%m-%d'), STR_TO_DATE('2025-08-25', '%Y-%m-%d'), 24, 26, 19),
(19, STR_TO_DATE('2025-04-01', '%Y-%m-%d'), STR_TO_DATE('2025-10-01', '%Y-%m-%d'), 22, 8, 2),
(20, STR_TO_DATE('2025-05-05', '%Y-%m-%d'), STR_TO_DATE('2025-11-05', '%Y-%m-%d'), 2, 18, 10),
(21, STR_TO_DATE('2025-06-10', '%Y-%m-%d'), STR_TO_DATE('2025-12-10', '%Y-%m-%d'), 16, 20, 4),
(22, STR_TO_DATE('2025-07-15', '%Y-%m-%d'), STR_TO_DATE('2026-01-15', '%Y-%m-%d'), 10, 24, 12),
(23, STR_TO_DATE('2025-08-20', '%Y-%m-%d'), STR_TO_DATE('2026-02-20', '%Y-%m-%d'), 27, 6, 25),
(24, STR_TO_DATE('2025-09-25', '%Y-%m-%d'), STR_TO_DATE('2026-03-25', '%Y-%m-%d'), 9, 14, 7),
(25, STR_TO_DATE('2025-10-30', '%Y-%m-%d'), STR_TO_DATE('2026-04-30', '%Y-%m-%d'), 6, 18, 20),
(26, STR_TO_DATE('2025-12-05', '%Y-%m-%d'), STR_TO_DATE('2026-06-05', '%Y-%m-%d'), 18, 26, 3),
(27, STR_TO_DATE('2026-01-10', '%Y-%m-%d'), STR_TO_DATE('2026-07-10', '%Y-%m-%d'), 8, 4, 17),
(28, STR_TO_DATE('2026-02-15', '%Y-%m-%d'), STR_TO_DATE('2026-08-15', '%Y-%m-%d'), 25, 10, 24),
(29, STR_TO_DATE('2026-03-20', '%Y-%m-%d'), STR_TO_DATE('2026-09-20', '%Y-%m-%d'), 3, 22, 28),
(30, STR_TO_DATE('2026-04-25', '%Y-%m-%d'), STR_TO_DATE('2026-10-25', '%Y-%m-%d'), 26, 28, 1);

INSERT INTO punjenje (id, id_transakcija_punjenje, id_vozilo, kolicina, tip_punjenja) VALUES -- Vedrana
(1, 12, 3, 45.5, 'benzin'),
(2, 8, 22, 60.2, 'dizel'),
(3, 20, 14, 35.8, 'električno'),
(4, 4, 16, 42.3, 'plin'),
(5, 25, 20, 55.1, 'benzin'),
(6, 27, 30, 48.6, 'dizel'),
(7, 17, 4, 39.9, 'električno'),
(8, 9, 23, 57.4, 'plin'),
(9, 18, 3, 43.7, 'benzin'),
(10, 3, 16, 50.8, 'dizel'),
(11, 29, 12, 38.5, 'električno'),
(12, 22, 29, 52.9, 'plin'),
(13, 7, 10, 47.3, 'benzin'),
(14, 2, 21, 34.6, 'dizel'),
(15, 21, 2, 56.7, 'električno'),
(16, 12, 17, 41.2, 'plin'),
(17, 28, 20, 48.3, 'benzin'),
(18, 14, 22, 37.4, 'dizel'),
(19, 26, 6, 53.2, 'električno'),
(20, 10, 25, 46.8, 'plin'),
(21, 24, 19, 51.5, 'benzin'),
(22, 8, 1, 36.7, 'dizel'),
(23, 30, 26, 54.6, 'električno'),
(24, 6, 14, 40.9, 'plin'),
(25, 19, 9, 49.1, 'benzin'),
(26, 1, 24, 33.7, 'dizel'),
(27, 16, 8, 52.4, 'električno'),
(28, 13, 27, 37.8, 'plin'),
(29, 23, 26, 55.7, 'benzin'),
(30, 4, 18, 44.6, 'dizel');

INSERT INTO odrzavanje (id, tip, id_zaposlenik, id_transakcija_odrzavanje) VALUES -- Marinela
(1, 'Godišnji servis', 17, 5),
(2, 'Godišnji servis', 29, 13),
(3, 'Zamjena ulja', 5, 8),
(4, 'Zamjena filtera', 23, 16),
(5, 'Popravak kočnica', 8, 3),
(6, 'Ispitivanje guma', 18, 29),
(7, 'Popravak karoserije', 30, 1),
(8, 'Punjenje klima uređaja', 10, 12),
(9, 'Balansiranje kotača', 9, 19),
(10, 'Zamjena svjećica', 11, 4),
(11, 'Servis kočnica', 20, 18),
(12, 'Zamjena akumulatora', 21, 25),
(13, 'Zamjena auspuha', 14, 20),
(14, 'Servis brave', 4, 15),
(15, 'Popravak upravljača', 3, 22),
(16, 'Zamjena diskova', 25, 24),
(17, 'Popravak amortizera', 13, 10),
(18, 'Zamjena svjetala', 12, 7),
(19, 'Servis motora', 1, 27),
(20, 'Popravak elektronike', 24, 30),
(21, 'Zamjena remenja', 28, 11),
(22, 'Servis kvačila', 6, 14),
(23, 'Popravak auspuha', 19, 23),
(24, 'Zamjena brisača', 16, 2),
(25, 'Popravak mjerača', 22, 6),
(26, 'Zamjena brave', 27, 21),
(27, 'Zamjena trapa', 15, 17),
(28, 'Servis akumulatora', 7, 9),
(29, 'Zamjena stakla', 2, 28),
(30, 'Popravak podvozja', 26, 26);

INSERT INTO rezervacija (id, datum_rezervacije, datum_potvrde, id_klijent) VALUES -- Marinela
(1, STR_TO_DATE('2023-02-15', '%Y-%m-%d'), STR_TO_DATE('2023-02-20', '%Y-%m-%d'), 12),
(2, STR_TO_DATE('2023-05-08', '%Y-%m-%d'), STR_TO_DATE('2023-05-15', '%Y-%m-%d'), 25),
(3, STR_TO_DATE('2023-09-20', '%Y-%m-%d'), STR_TO_DATE('2023-09-25', '%Y-%m-%d'), 5),
(4, STR_TO_DATE('2023-11-11', '%Y-%m-%d'), STR_TO_DATE('2023-11-17', '%Y-%m-%d'), 30),
(5, STR_TO_DATE('2023-12-04', '%Y-%m-%d'), STR_TO_DATE('2023-12-10', '%Y-%m-%d'), 18),
(6, STR_TO_DATE('2023-06-21', '%Y-%m-%d'), STR_TO_DATE('2023-06-28', '%Y-%m-%d'), 3),
(7, STR_TO_DATE('2023-04-12', '%Y-%m-%d'), STR_TO_DATE('2023-04-19', '%Y-%m-%d'), 10),
(8, STR_TO_DATE('2023-08-30', '%Y-%m-%d'), STR_TO_DATE('2023-09-06', '%Y-%m-%d'), 15),
(9, STR_TO_DATE('2023-10-25', '%Y-%m-%d'), STR_TO_DATE('2023-11-01', '%Y-%m-%d'), 22),
(10, STR_TO_DATE('2023-01-17', '%Y-%m-%d'), STR_TO_DATE('2023-01-24', '%Y-%m-%d'), 7),
(11, STR_TO_DATE('2023-07-09', '%Y-%m-%d'), STR_TO_DATE('2023-07-16', '%Y-%m-%d'), 30),
(12, STR_TO_DATE('2023-03-28', '%Y-%m-%d'), STR_TO_DATE('2023-04-04', '%Y-%m-%d'), 12),
(13, STR_TO_DATE('2023-12-10', '%Y-%m-%d'), STR_TO_DATE('2023-12-17', '%Y-%m-%d'), 28),
(14, STR_TO_DATE('2023-02-02', '%Y-%m-%d'), STR_TO_DATE('2023-02-09', '%Y-%m-%d'), 6),
(15, STR_TO_DATE('2023-05-30', '%Y-%m-%d'), STR_TO_DATE('2023-06-06', '%Y-%m-%d'), 14),
(16, STR_TO_DATE('2023-09-12', '%Y-%m-%d'), STR_TO_DATE('2023-09-19', '%Y-%m-%d'), 2),
(17, STR_TO_DATE('2023-11-26', '%Y-%m-%d'), STR_TO_DATE('2023-12-03', '%Y-%m-%d'), 25),
(18, STR_TO_DATE('2023-06-17', '%Y-%m-%d'), STR_TO_DATE('2023-06-24', '%Y-%m-%d'), 18),
(19, STR_TO_DATE('2023-04-20', '%Y-%m-%d'), STR_TO_DATE('2023-04-27', '%Y-%m-%d'), 11),
(20, STR_TO_DATE('2023-08-03', '%Y-%m-%d'), STR_TO_DATE('2023-08-10', '%Y-%m-%d'), 30),
(21, STR_TO_DATE('2023-10-29', '%Y-%m-%d'), STR_TO_DATE('2023-11-05', '%Y-%m-%d'), 3),
(22, STR_TO_DATE('2023-01-30', '%Y-%m-%d'), STR_TO_DATE('2023-02-06', '%Y-%m-%d'), 19),
(23, STR_TO_DATE('2023-07-23', '%Y-%m-%d'), STR_TO_DATE('2023-07-30', '%Y-%m-%d'), 12),
(24, STR_TO_DATE('2023-03-17', '%Y-%m-%d'), STR_TO_DATE('2023-03-24', '%Y-%m-%d'), 27),
(25, STR_TO_DATE('2023-11-05', '%Y-%m-%d'), STR_TO_DATE('2023-11-12', '%Y-%m-%d'), 5),
(26, STR_TO_DATE('2023-02-22', '%Y-%m-%d'), STR_TO_DATE('2023-03-01', '%Y-%m-%d'), 20),
(27, STR_TO_DATE('2023-06-05', '%Y-%m-%d'), STR_TO_DATE('2023-06-12', '%Y-%m-%d'), 7),
(28, STR_TO_DATE('2023-09-26', '%Y-%m-%d'), STR_TO_DATE('2023-10-03', '%Y-%m-%d'), 18),
(29, STR_TO_DATE('2023-01-13', '%Y-%m-%d'), STR_TO_DATE('2023-01-20', '%Y-%m-%d'), 29),
(30, STR_TO_DATE('2023-05-19', '%Y-%m-%d'), STR_TO_DATE('2023-05-26', '%Y-%m-%d'), 4);

INSERT INTO oprema (id, naziv, opis) VALUES -- Marinela
(1, 'Wi-fi uređaj', 'wi-fi hotspot, spajanje 5 uređaja istovremeno, 32 GB memorije'),
(2, 'GPS navigacija', 'Uključuje nosače za vjetrobransko staklo, Upozorenje na kamere za kontrolu brzine na vašoj ruti'),
(3, 'Pomoć na cesti', 'Popravak vozila na cesti, vuča vozila'),
(4, 'Dječja sjedalica baby seat', 'Sjedalica za djecu od 0-12 mj'),
(5, 'Dječja sjedalica child seat', 'Sjedalica za djecu od 9-36kg'),
(6, 'Dječja sjedalica booster seat', 'Sjedalica za djecu od 4 do 7 godina'),
(7, 'Nosači za bicikle', 'Krovni nosači za dva bicikla'),
(8, 'Motorističke kacige', 'Otvorena kaciga s vizirom'),
(9, 'Autoprikolica', 'Nosivost 750kg'),
(10, 'Motorističke rukavice', 'Pružaju zaštitu ruku od vjetra, sunca i ozljeda'),
(11, 'Bočne bisage', 'Za veću pohranu – alat, odjeća'),
(12, 'Stražnje bisage', 'Za pohranu manje količine stvari'),
(13, 'Nosači za svijetla', 'Za pričvršćivanje dodatnih svjetala ili reflektora na kamion');

INSERT INTO oprema_na_najmu (id, id_oprema, id_najam_vozila, kolicina, status_opreme, datum_pocetka_najma, datum_zavrsetka_najma) VALUES -- Marinela
(1, 7, 24, 10, 'iznajmljeno', STR_TO_DATE('2024-04-20', '%Y-%m-%d'), STR_TO_DATE('2024-04-27', '%Y-%m-%d')),
(2, 4, 18, 15, 'dostupno', STR_TO_DATE('2023-08-08', '%Y-%m-%d'), STR_TO_DATE('2023-08-15', '%Y-%m-%d')),
(3, 9, 7, 8, 'rezervirano', STR_TO_DATE('2023-12-10', '%Y-%m-%d'), STR_TO_DATE('2023-12-17', '%Y-%m-%d')),
(4, 8, 1, 7, 'iznajmljeno', STR_TO_DATE('2024-02-29', '%Y-%m-%d'), STR_TO_DATE('2024-03-09', '%Y-%m-%d')),
(5, 10, 3, 10, 'dostupno', STR_TO_DATE('2023-07-01', '%Y-%m-%d'), STR_TO_DATE('2023-07-09', '%Y-%m-%d')),
(6, 1, 20, 5, 'iznajmljeno', STR_TO_DATE('2024-01-15', '%Y-%m-%d'), STR_TO_DATE('2024-01-24', '%Y-%m-%d')),
(7, 5, 29, 6, 'dostupno', STR_TO_DATE('2023-10-20', '%Y-%m-%d'), STR_TO_DATE('2023-10-27', '%Y-%m-%d')),
(8, 3, 5, 12, 'iznajmljeno', STR_TO_DATE('2023-11-11', '%Y-%m-%d'), STR_TO_DATE('2023-11-21', '%Y-%m-%d')),
(9, 4, 28, 3, 'rezervirano', STR_TO_DATE('2023-09-05', '%Y-%m-%d'), STR_TO_DATE('2023-09-15', '%Y-%m-%d')),
(10, 2, 6, 20, 'dostupno', STR_TO_DATE('2024-02-14', '%Y-%m-%d'), STR_TO_DATE('2024-02-23', '%Y-%m-%d')),
(11, 6, 15, 8, 'iznajmljeno', STR_TO_DATE('2023-05-12', '%Y-%m-%d'), STR_TO_DATE('2023-05-21', '%Y-%m-%d')),
(12, 7, 9, 10, 'dostupno', STR_TO_DATE('2024-06-02', '%Y-%m-%d'), STR_TO_DATE('2024-06-09', '%Y-%m-%d')),
(13, 8, 11, 7, 'rezervirano', STR_TO_DATE('2023-04-09', '%Y-%m-%d'), STR_TO_DATE('2023-04-16', '%Y-%m-%d')),
(14, 10, 22, 15, 'iznajmljeno', STR_TO_DATE('2024-03-27', '%Y-%m-%d'), STR_TO_DATE('2024-03-05', '%Y-%m-%d')),
(15, 1, 14, 6, 'dostupno', STR_TO_DATE('2023-01-20', '%Y-%m-%d'), STR_TO_DATE('2023-01-27', '%Y-%m-%d')),
(16, 3, 17, 8, 'iznajmljeno', STR_TO_DATE('2024-06-05', '%Y-%m-%d'), STR_TO_DATE('2024-06-13', '%Y-%m-%d')),
(17, 2, 26, 4, 'rezervirano', STR_TO_DATE('2023-08-08', '%Y-%m-%d'), STR_TO_DATE('2023-08-16', '%Y-%m-%d')),
(18, 6, 2, 10, 'dostupno', STR_TO_DATE('2024-05-07', '%Y-%m-%d'), STR_TO_DATE('2024-05-16', '%Y-%m-%d')),
(19, 7, 25, 13, 'iznajmljeno', STR_TO_DATE('2023-11-28', '%Y-%m-%d'), STR_TO_DATE('2023-12-06', '%Y-%m-%d')),
(20, 8, 8, 9, 'dostupno', STR_TO_DATE('2024-03-10', '%Y-%m-%d'), STR_TO_DATE('2024-03-19', '%Y-%m-%d')),
(21, 10, 16, 5, 'iznajmljeno', STR_TO_DATE('2023-07-30', '%Y-%m-%d'), STR_TO_DATE('2023-08-07', '%Y-%m-%d')),
(22, 1, 30, 11, 'dostupno', STR_TO_DATE('2024-01-02', '%Y-%m-%d'), STR_TO_DATE('2024-01-13', '%Y-%m-%d')),
(23, 5, 10, 8, 'iznajmljeno', STR_TO_DATE('2023-10-18', '%Y-%m-%d'), STR_TO_DATE('2023-10-27', '%Y-%m-%d')),
(24, 2, 21, 6, 'dostupno', STR_TO_DATE('2024-04-04', '%Y-%m-%d'), STR_TO_DATE('2024-04-12', '%Y-%m-%d')),
(25, 3, 27, 12, 'iznajmljeno', STR_TO_DATE('2023-12-15', '%Y-%m-%d'), STR_TO_DATE('2023-12-25', '%Y-%m-%d')),
(26, 4, 4, 3, 'dostupno', STR_TO_DATE('2024-01-01', '%Y-%m-%d'), STR_TO_DATE('2024-01-08', '%Y-%m-%d')),
(27, 6, 19, 20, 'iznajmljeno', STR_TO_DATE('2023-09-02', '%Y-%m-%d'), STR_TO_DATE('2023-09-11', '%Y-%m-%d')),
(28, 7, 13, 9, 'dostupno', STR_TO_DATE('2024-03-28', '%Y-%m-%d'), STR_TO_DATE('2024-04-06', '%Y-%m-%d')),
(29, 9, 23, 5, 'iznajmljeno', STR_TO_DATE('2023-06-10', '%Y-%m-%d'), STR_TO_DATE('2023-06-17', '%Y-%m-%d')),
(30, 10, 12, 14, 'dostupno', STR_TO_DATE('2024-05-19', '%Y-%m-%d'), STR_TO_DATE('2024-05-27', '%Y-%m-%d'));

INSERT INTO oprema_na_rezervaciji (id, id_rezervacija, id_oprema, kolicina) VALUES -- Marinela
(1, 23, 12, 1),
(2, 8, 4, 2),
(3, 14, 9, 1),
(4, 30, 3, 1),
(5, 6, 6, 1),
(6, 19, 5, 1),
(7, 11, 2, 1),
(8, 3, 10, 2),
(9, 27, 7, 1),
(10, 5, 12, 1),
(11, 29, 1, 1),
(12, 2, 4, 2),
(13, 18, 11, 1),
(14, 7, 6, 1),
(15, 21, 9, 1),
(16, 12, 7, 1),
(17, 1, 10, 2),
(18, 25, 5, 1),
(19, 9, 8, 2),
(20, 15, 1, 1),
(21, 28, 3, 1),
(22, 17, 11, 1),
(23, 22, 2, 1),
(24, 4, 8, 2),
(25, 16, 4, 1),
(26, 26, 10, 2),
(27, 20, 6, 2),
(28, 10, 9, 1),
(29, 24, 5, 1),
(30, 13, 7, 1);

INSERT INTO vozilo_na_rezervaciji (id, id_vozilo, id_rezervacija) VALUES -- Marinela
(1, 23, 4),
(2, 6, 26),
(3, 7, 30),
(4, 29, 15),
(5, 25, 7),
(6, 2, 12),
(7, 14, 29),
(8, 14, 5),
(9, 15, 9),
(10, 5, 25),
(11, 17, 20),
(12, 15, 3),
(13, 6, 22),
(14, 11, 23),
(15, 1, 6),
(16, 12, 27),
(17, 22, 11),
(18, 7, 14),
(19, 6, 10),
(20, 12, 8),
(21, 8, 19),
(22, 9, 24),
(23, 17, 18),
(24, 3, 21),
(25, 5, 1),
(26, 16, 17),
(27, 2, 13),
(28, 11, 2),
(29, 20, 16),
(30, 29, 28);

INSERT INTO crna_lista (id, id_klijent, razlog) VALUES -- Marinela
(1, 2, 'Nepoštivanje uvjeta ugovora'),
(2, 9, 'Ponavljanje prekršaja'),
(3, 29, 'Korištenje vozila za nezakonite svrhe'),
(4, 24, 'Ponavljanje prekršaja'),
(5, 11, 'Neplaćanje računa'),
(6, 14, 'Oštećenje vozila');

-- 1.Pronađi sve klijente koji su na crnoj listi - Marinela
SELECT k.id, k.ime, k.prezime
FROM klijent k
JOIN crna_lista cl ON k.id = cl.id_klijent;

-- 2.Izlistaj sve serije automobila koje imaju automatski tip mjenjača - Marinela
SELECT *
FROM serija_auto_kamion sak
JOIN automobil a ON sak.id = a.id_serija_auto_kamion
WHERE sak.tip_mjenjaca = 'Automatski';

-- 3.Prikaži ukupan broj iznajmljenih komada određene opreme po rezervaciji - Marinela
SELECT r.id, o.naziv, SUM(onr.kolicina) AS broj_komada
FROM rezervacija r
JOIN oprema_na_rezervaciji onr ON r.id = onr.id_rezervacija
JOIN oprema o ON onr.id_oprema = o.id
GROUP BY r.id, o.naziv;

-- 4.Prikaži sve rezervacije koje uključuju opremu 'GPS navigacija' i poredaj ih po datumu rezervacije
-- Marinela
SELECT r.*, o.*
FROM rezervacija r
JOIN oprema_na_rezervaciji onr ON r.id = onr.id_rezervacija
JOIN oprema o ON onr.id_oprema = o.id
WHERE o.naziv = 'GPS navigacija'
ORDER BY r.datum_rezervacije;

-- 5.Pregled ukupnog broja transakcija po vrsti plaćanja - Marinela
SELECT tip_placanja, COUNT(*) AS broj_transakcija
FROM (
    SELECT 'Gotovinsko' AS tip_placanja FROM gotovinsko_placanje
    UNION ALL
    SELECT 'Kartično' AS tip_placanja FROM karticno_placanje
    UNION ALL
    SELECT 'Kriptovalutno' AS tip_placanja FROM kriptovalutno_placanje
) AS sve_transakcije
GROUP BY tip_placanja;



