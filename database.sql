PGDMP  #                    |            FlaskApp    16.0    16.0     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    262316    FlaskApp    DATABASE     �   CREATE DATABASE "FlaskApp" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "FlaskApp";
                postgres    false            �            1259    262318    invoice    TABLE     �   CREATE TABLE public.invoice (
    id integer NOT NULL,
    invoice_number character varying(100) NOT NULL,
    invoice_date date,
    customer_name character varying(100) NOT NULL
);
    DROP TABLE public.invoice;
       public         heap    postgres    false            �            1259    262317    invoice_id_seq    SEQUENCE     �   CREATE SEQUENCE public.invoice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.invoice_id_seq;
       public          postgres    false    216            �           0    0    invoice_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.invoice_id_seq OWNED BY public.invoice.id;
          public          postgres    false    215            �            1259    262327    invoice_line_item    TABLE     �   CREATE TABLE public.invoice_line_item (
    id integer NOT NULL,
    item_name character varying(100) NOT NULL,
    quantity integer,
    unit_price real NOT NULL,
    tax integer,
    invoice_id integer NOT NULL
);
 %   DROP TABLE public.invoice_line_item;
       public         heap    postgres    false            �            1259    262326    invoice_line_item_id_seq    SEQUENCE     �   CREATE SEQUENCE public.invoice_line_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.invoice_line_item_id_seq;
       public          postgres    false    218            �           0    0    invoice_line_item_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.invoice_line_item_id_seq OWNED BY public.invoice_line_item.id;
          public          postgres    false    217                       2604    262321 
   invoice id    DEFAULT     h   ALTER TABLE ONLY public.invoice ALTER COLUMN id SET DEFAULT nextval('public.invoice_id_seq'::regclass);
 9   ALTER TABLE public.invoice ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215    216                        2604    262330    invoice_line_item id    DEFAULT     |   ALTER TABLE ONLY public.invoice_line_item ALTER COLUMN id SET DEFAULT nextval('public.invoice_line_item_id_seq'::regclass);
 C   ALTER TABLE public.invoice_line_item ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217    218            �          0    262318    invoice 
   TABLE DATA           R   COPY public.invoice (id, invoice_number, invoice_date, customer_name) FROM stdin;
    public          postgres    false    216   p       �          0    262327    invoice_line_item 
   TABLE DATA           a   COPY public.invoice_line_item (id, item_name, quantity, unit_price, tax, invoice_id) FROM stdin;
    public          postgres    false    218   �       �           0    0    invoice_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.invoice_id_seq', 3, true);
          public          postgres    false    215            �           0    0    invoice_line_item_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_line_item_id_seq', 5, true);
          public          postgres    false    217            "           2606    262325 "   invoice invoice_invoice_number_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_invoice_number_key UNIQUE (invoice_number);
 L   ALTER TABLE ONLY public.invoice DROP CONSTRAINT invoice_invoice_number_key;
       public            postgres    false    216            &           2606    262332 (   invoice_line_item invoice_line_item_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.invoice_line_item
    ADD CONSTRAINT invoice_line_item_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.invoice_line_item DROP CONSTRAINT invoice_line_item_pkey;
       public            postgres    false    218            $           2606    262323    invoice invoice_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.invoice DROP CONSTRAINT invoice_pkey;
       public            postgres    false    216            '           2606    262333 3   invoice_line_item invoice_line_item_invoice_id_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_line_item
    ADD CONSTRAINT invoice_line_item_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoice(id);
 ]   ALTER TABLE ONLY public.invoice_line_item DROP CONSTRAINT invoice_line_item_invoice_id_fkey;
       public          postgres    false    218    216    4644            �   .   x�3�40�4202�50�52��M,��2�40Bqz%fr��qqq �v�      �   @   x�3�IL�I�44�42�36�44�4�2�t�H�,�4�46�35��r�%恄@�\1z\\\ ��     