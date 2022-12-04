--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.5

-- Started on 2022-12-04 12:00:01

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3334 (class 1262 OID 24586)
-- Name: Barbershop; Type: DATABASE; Schema: -; Owner: postgres
--

-- CREATE DATABASE "Barbershop" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Russian_Russia.1251';


-- ALTER DATABASE "Barbershop" OWNER TO postgres;

-- \connect "Barbershop"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 215 (class 1255 OID 24643)
-- Name: is_out_of_day(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_out_of_day() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
emp record;
BEGIN
FOR emp IN (SELECT * FROM is_not_busy ORDER BY start_time)
LOOP
if(emp.end_time>'18:00:00')
THEN RAISE EXCEPTION 'time is busy';
END IF;
END LOOP;
RETURN NEW;
END;$$;


ALTER FUNCTION public.is_out_of_day() OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 24630)
-- Name: this_time_busy(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.this_time_busy() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
emp record;
curr_end time without time zone;
BEGIN
FOR emp IN (SELECT business.start_time,
    business.start_time + (( SELECT services.duration
           FROM services
          WHERE services.serv_id::text = business.serv_key::text)) AS end_time
   FROM business WHERE date = new.date
  ORDER BY business.start_time)
LOOP
if(emp.start_time<curr_end)
THEN RAISE EXCEPTION 'time is busy';
END IF;
curr_end:=emp.end_time;
END LOOP;
RETURN NEW;
END;$$;


ALTER FUNCTION public.this_time_busy() OWNER TO postgres;

--
-- TOC entry 214 (class 1255 OID 24611)
-- Name: uncorrect_date(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.uncorrect_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
if(NEW.DATE<=CURRENT_DATE)
THEN RAISE EXCEPTION 'Uncorrect date!';
END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.uncorrect_date() OWNER TO postgres;

--
-- TOC entry 213 (class 1255 OID 24608)
-- Name: uncorrect_time(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.uncorrect_time() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
if((NEW.start_time<'08:00:00')or(NEW.start_time>'18:00:00'))
THEN RAISE EXCEPTION 'Uncorrect time!';
END IF;
RETURN NEW;
END;$$;


ALTER FUNCTION public.uncorrect_time() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 24592)
-- Name: business; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.business (
    start_time time without time zone NOT NULL,
    date date NOT NULL,
    serv_key character varying(2) NOT NULL,
    user_name character varying(12) NOT NULL,
    busy_id integer NOT NULL
);


ALTER TABLE public.business OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 24646)
-- Name: business_busy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.business ALTER COLUMN busy_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.business_busy_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 9999
    CACHE 1
);


--
-- TOC entry 209 (class 1259 OID 24587)
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    serv_id character varying(2) NOT NULL,
    name character varying(20),
    duration interval
);


ALTER TABLE public.services OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 24639)
-- Name: is_not_busy; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.is_not_busy AS
 SELECT business.start_time,
    (business.start_time + ( SELECT services.duration
           FROM public.services
          WHERE ((services.serv_id)::text = (business.serv_key)::text))) AS end_time
   FROM public.business
  ORDER BY business.start_time;


ALTER TABLE public.is_not_busy OWNER TO postgres;

--
-- TOC entry 3327 (class 0 OID 24592)
-- Dependencies: 210
-- Data for Name: business; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3326 (class 0 OID 24587)
-- Dependencies: 209
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.services (serv_id, name, duration) VALUES ('13', 'Blow-drying', '00:10:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('11', 'Highlighting of l', '01:00:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('07', 'Waxing', '00:20:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('02', 'Hair treatment', '01:30:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('01', 'Hair coloring', '00:40:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('03', 'Bio-straightening', '03:00:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('04', 'Hair extensions', '01:30:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('05', 'Hair curling', '00:40:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('06', 'Man`s haircut
', '00:20:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('15', 'Royal shaving', '00:30:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('08', 'Hair styling', '00:20:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('09', 'Highlighting of s', '00:40:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('10', 'Highlighting of m-l', '00:50:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('12', 'Trimming the tips', '00:20:00');
INSERT INTO public.services (serv_id, name, duration) VALUES ('14', 'Children`s haircut', '00:20:00');


--
-- TOC entry 3335 (class 0 OID 0)
-- Dependencies: 212
-- Name: business_busy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.business_busy_id_seq', 31, true);


--
-- TOC entry 3179 (class 2606 OID 24652)
-- Name: business business_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business
    ADD CONSTRAINT business_pkey PRIMARY KEY (busy_id);


--
-- TOC entry 3177 (class 2606 OID 24591)
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (serv_id);


--
-- TOC entry 3180 (class 1259 OID 24602)
-- Name: fki_service; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_service ON public.business USING btree (serv_key);


--
-- TOC entry 3182 (class 2620 OID 24645)
-- Name: business busy_time; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER busy_time AFTER INSERT OR UPDATE OF start_time, date, serv_key ON public.business FOR EACH ROW EXECUTE FUNCTION public.this_time_busy();


--
-- TOC entry 3183 (class 2620 OID 24644)
-- Name: business is_out_of_day; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER is_out_of_day AFTER INSERT OR UPDATE OF start_time, serv_key ON public.business FOR EACH ROW EXECUTE FUNCTION public.is_out_of_day();


--
-- TOC entry 3184 (class 2620 OID 24612)
-- Name: business uncorrect_date; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER uncorrect_date BEFORE INSERT OR UPDATE OF date ON public.business FOR EACH ROW EXECUTE FUNCTION public.uncorrect_date();


--
-- TOC entry 3185 (class 2620 OID 24609)
-- Name: business uncorrect_time; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER uncorrect_time BEFORE INSERT OR UPDATE OF start_time ON public.business FOR EACH ROW EXECUTE FUNCTION public.uncorrect_time();


--
-- TOC entry 3181 (class 2606 OID 24597)
-- Name: business service; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business
    ADD CONSTRAINT service FOREIGN KEY (serv_key) REFERENCES public.services(serv_id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


-- Completed on 2022-12-04 12:00:01

--
-- PostgreSQL database dump complete
--

