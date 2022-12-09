--1) vista per mostrare le informazioni nutrizionali dei prodotti 
create or replace view info_prodotti (nome_prodotto, categoria, componente, quantita_per_100g, quantita_per_prodotto, RDA)
as 
        select max(pr.nome_prodotto), max(pr.categoria_prod), max(info_nu.componente), max(info_nu.quantita_per_100g), max(info_nu.quantita_per_prod), max(info_nu.RDA)
        from prodotto pr join informazioni_nutrizionali info_nu on pr.cod_barre_prodotto = info_nu.prod_riferito
        order by pr.nome_prodotto; 
/

--2) vista che mostra le componenti di un prodotto 
create or replace view componenti_prodotto (nome_prodotto, componente, quantita_merce)
as
        select pr.nome_prodotto, me.nome_merce, pr_comp.quantita_merce
        from prodotto pr join prodotto_composto_da pr_comp on pr.cod_barre_prodotto = pr_comp.prodotto
                join merce me on pr_comp.componente = me.nome_merce
        order by pr.nome_prodotto; 
/

--2) vista per mostrare le componenti di un menu standard
create or replace view componenti_menu (menu, tipo_menu, prodotti, categoria, grandezza, quantita)
as 
        select max(mstd.codice_menu), max(mstd.tipo_menu), max(pr.nome_prodotto), max(pr.categoria_prod), max(pr.grandezza_prod), max(m_con_pr.quantita_prodotto)
        from menu_standard mstd join menu_contiene_prod m_con_pr on mstd.codice_menu = m_con_pr.cod_menu
                join prodotto pr on m_con_pr.prodotto = pr.cod_barre_prodotto
        order by mstd.codice_menu;
/

--3) vista per mostrare cosa contiene un offerta legata ai menu 
create or replace view componenti_offerta_menu_std (offerta, inizio, fine, prezzo, menu, quantita_menu, prodotto, grandezza)
as 
        select oft.codice_offerta, oft.data_inizio, oft.data_fine, oft.prezzo_offerta, oft_con_mstd.cod_menu_std, oft_con_mstd.quantita_menu_std, pr.nome_prodotto, pr.grandezza_prod
        from offerte oft join offerta_contiene_menu oft_con_mstd on oft.codice_offerta = oft_con_mstd.cod_offerta
            join menu_standard mstd on oft_con_mstd.cod_menu_std = mstd.codice_menu 
            join menu_contiene_prod mstd_con_prod on mstd.codice_menu = mstd_con_prod.cod_menu
            join prodotto pr on mstd_con_prod.prodotto = pr.cod_barre_prodotto
        order by oft.codice_offerta;
/        

--4) vista per mostrare cosa contiene un offerta legata ai prodotti
create or replace view componenti_offerta_prodotto (offerta, inizio, fine, prezzo, prodotto, grandezza)
as 

        select oft.codice_offerta, oft.data_inizio, oft.data_fine, oft.prezzo_offerta, pr.nome_prodotto, pr.grandezza_prod
        from offerte oft join offerta_contiene_prod oft_con_prod on oft.codice_offerta = oft_con_prod.cod_offerta
            join prodotto pr on oft_con_prod.prodotto = pr.cod_barre_prodotto
        order by oft.codice_offerta;
/

--5) per visualizzare le offerte che contengono sia menu che prodotti singoli 
select * from componenti_offerta_prodotto oft_prod join componenti_offerta_menu_std oft_menu on oft_prod.offerta = oft_menu.offerta; 
/

--6) vista che mostra quali componenti sono in una data area del magazzino 
create or replace view mostra_merce_magazzino (codice_area, categoria_area, tipo_conservazione, merce_contenuta, categoria_merce)
as
        select mag.cod_area, mag.categoria_area, mag.tipo_conservazione, me.nome_merce, me.categoria_merce
        from magazzino mag join ordine_rifornimento ord_rif on mag.cod_area = ord_rif.codice_area_mag
                join lotto lo on ord_rif.cod_ordine_rif = lo.ordine_rif
                join merce me on lo.merce_contenuta = me.nome_merce
        order by mag.cod_area;
/        

--7) vista che mostra i turni di lavoro
create or replace view mostra_turni (data_turno, tessera_personale, nome_personale, cognome_personale, ruolo)
as
        select tu.data_turno, per.tessera, per.nome, per.cognome, per.ruolo
        from personale per join turni tu on per.tessera = tu.cod_personale
        order by per.tessera, tu.data_turno; 
/        
        