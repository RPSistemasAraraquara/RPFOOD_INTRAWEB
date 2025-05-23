toc.dat                                                                                             0000600 0004000 0002000 00000140610 14757377176 0014471 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP   *                    }            FOOD    17.2    17.2 n    L           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false         M           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false         N           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false         O           1262    440514    FOOD    DATABASE     }   CREATE DATABASE "FOOD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE "FOOD";
                     postgres    false         �            1255    440515    is_atendimento_disponivel()    FUNCTION     �	  CREATE FUNCTION public.is_atendimento_disponivel() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    atendimento_disponivel BOOLEAN := false;
    config configuracao_funcionamento%ROWTYPE;
    current_day_of_week INTEGER;
    current_local_time TIME;
BEGIN
    -- Obter o dia da semana atual (0 para domingo, 1 para segunda-feira, 2 para terça-feira, etc.)
    current_day_of_week := EXTRACT(DOW FROM CURRENT_DATE)::INTEGER;

    -- Obter o horário atual em 'America/Sao_Paulo'
    current_local_time := (SELECT Current_Time at time zone 'America/Sao_Paulo');

    -- Obter as configurações de atendimento
    SELECT * INTO config FROM configuracao_funcionamento LIMIT 1;

    -- Verificar se o atendimento está disponível no dia da semana atual
    CASE current_day_of_week
        WHEN 1 THEN
            atendimento_disponivel := config.dia_segunda AND
                current_local_time >= config.segunda_inicio_atendimento AND
                current_local_time <= config.segunda_fim_atendimento;
        WHEN 2 THEN
            atendimento_disponivel := config.dia_terca AND
                current_local_time >= config.terca_inicio_atendimento AND
                current_local_time <= config.terca_fim_atendimento;
        WHEN 3 THEN
            atendimento_disponivel := config.dia_quarta AND
                current_local_time >= config.quarta_inicio_atendimento AND
                current_local_time <= config.quarta_fim_atendimento;
        WHEN 4 THEN
            atendimento_disponivel := config.dia_quinta AND
                current_local_time >= config.quinta_inicio_atendimento AND
                current_local_time <= config.quinta_fim_atendimento;
        WHEN 5 THEN
            atendimento_disponivel := config.dia_sexta AND
                current_local_time >= config.sexta_inicio_atendimento AND
                current_local_time <= config.sexta_fim_atendimento;
        WHEN 6 THEN
            atendimento_disponivel := config.dia_sabado AND
                current_local_time >= config.sabado_inicio_atendimento AND
                current_local_time <= config.sabado_fim_atendimento;
        WHEN 0 THEN
            atendimento_disponivel := config.dia_domingo AND
                current_local_time >= config.domingo_inicio_atendimento AND
                current_local_time <= config.domingo_fim_atendimento;
    END CASE;

    RETURN atendimento_disponivel;
END;
$$;
 2   DROP FUNCTION public.is_atendimento_disponivel();
       public               postgres    false         �            1259    440516    bairro    TABLE       CREATE TABLE public.bairro (
    bai_001 integer NOT NULL,
    emp_001 integer NOT NULL,
    bai_002 character varying(60) NOT NULL,
    bai_003 numeric(15,2),
    sit_001 integer DEFAULT 4 NOT NULL,
    b_restricao_entrega boolean DEFAULT false NOT NULL
);
    DROP TABLE public.bairro;
       public         heap r       postgres    false         �            1259    440521    bairro_ceps    TABLE       CREATE TABLE public.bairro_ceps (
    bai_001 integer NOT NULL,
    emp_001 integer NOT NULL,
    cep character varying(9) NOT NULL,
    logradouro character varying(125),
    id_cidade integer,
    cidade_desc character varying(75),
    uf_sigla character varying(2)
);
    DROP TABLE public.bairro_ceps;
       public         heap r       postgres    false         �            1259    440524    clientes    TABLE     �  CREATE TABLE public.clientes (
    id_empresa integer DEFAULT 1 NOT NULL,
    cli_004 character varying(20),
    sit_001 integer DEFAULT 4 NOT NULL,
    observacao text,
    senha_email character varying(100),
    pontos_atuais integer,
    email character varying(100),
    tipo_pessoa character varying(1) DEFAULT 'F'::character varying,
    celular1 character varying(30),
    cli_001 integer NOT NULL,
    cli_012 character varying(50),
    cli_002 character varying(100)
);
    DROP TABLE public.clientes;
       public         heap r       postgres    false         �            1259    440532    clientes_cli_001_seq    SEQUENCE     �   ALTER TABLE public.clientes ALTER COLUMN cli_001 ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.clientes_cli_001_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    219         �            1259    440533    clientes_endereco    TABLE     �  CREATE TABLE public.clientes_endereco (
    id_endereco integer NOT NULL,
    cli_001 integer NOT NULL,
    id_empresa integer NOT NULL,
    cep_002 character varying(9),
    cep_003 character varying(50),
    cep_004 character varying(125),
    cli_007 character varying(80),
    cli_008 character varying(100),
    cli_009 character varying(100),
    bai_001 integer,
    endereco_padrao boolean DEFAULT false,
    taxa numeric(15,3),
    idcidade integer,
    uf character varying(50)
);
 %   DROP TABLE public.clientes_endereco;
       public         heap r       postgres    false         �            1259    440539 !   clientes_endereco_id_endereco_seq    SEQUENCE     �   ALTER TABLE public.clientes_endereco ALTER COLUMN id_endereco ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.clientes_endereco_id_endereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    221         �            1259    440540    configuracao_funcionamento    TABLE     m  CREATE TABLE public.configuracao_funcionamento (
    dia_segunda boolean DEFAULT false NOT NULL,
    dia_terca boolean DEFAULT false NOT NULL,
    dia_quarta boolean DEFAULT false NOT NULL,
    dia_quinta boolean DEFAULT false NOT NULL,
    dia_sexta boolean DEFAULT false NOT NULL,
    dia_sabado boolean DEFAULT false NOT NULL,
    dia_domingo boolean DEFAULT false NOT NULL,
    segunda_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    terca_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    quarta_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    quinta_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    sexta_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    sabado_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    domingo_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    segunda_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    terca_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    quarta_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    quinta_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    sexta_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    sabado_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    domingo_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    id_empresa integer NOT NULL,
    id integer NOT NULL
);
 .   DROP TABLE public.configuracao_funcionamento;
       public         heap r       postgres    false         �            1259    440564 !   configuracao_funcionamento_id_seq    SEQUENCE     �   CREATE SEQUENCE public.configuracao_funcionamento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.configuracao_funcionamento_id_seq;
       public               postgres    false    223         P           0    0 !   configuracao_funcionamento_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.configuracao_funcionamento_id_seq OWNED BY public.configuracao_funcionamento.id;
          public               postgres    false    224         �            1259    440565    configuracao_rpfood    TABLE     �  CREATE TABLE public.configuracao_rpfood (
    id_empresa integer DEFAULT 1 NOT NULL,
    tempo_retirada_rpfood integer DEFAULT 0 NOT NULL,
    tempo_entrega_rpfood integer DEFAULT 0 NOT NULL,
    utiliza_tipo_entrega_retirada boolean DEFAULT true,
    modo_acougue boolean DEFAULT false NOT NULL,
    pedido_minimo numeric(15,2) DEFAULT 0.00 NOT NULL,
    id integer NOT NULL,
    utiliza_controle_opcionais boolean DEFAULT false,
    utiliza_controle_ceps boolean DEFAULT true
);
 '   DROP TABLE public.configuracao_rpfood;
       public         heap r       postgres    false         �            1259    440576    configuracao_rpfood_id_seq    SEQUENCE     �   CREATE SEQUENCE public.configuracao_rpfood_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.configuracao_rpfood_id_seq;
       public               postgres    false    225         Q           0    0    configuracao_rpfood_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.configuracao_rpfood_id_seq OWNED BY public.configuracao_rpfood.id;
          public               postgres    false    226         �            1259    440577    empresas    TABLE       CREATE TABLE public.empresas (
    descricao character varying(40),
    codiuf integer,
    codicidade integer,
    uf character varying(2),
    cidade character varying(30),
    bairro character varying(30),
    endereco character varying(60),
    tipoendereco character varying(30),
    nome character varying(60),
    razsoc character varying(60),
    cnpj character varying(18),
    cep character varying(20),
    numero character varying(20),
    fone1 character varying(30),
    descrifone1 character varying(20),
    ddd1 character(3),
    email character varying(100),
    site character varying(100),
    complemento character varying(100),
    id_situacao integer DEFAULT 4 NOT NULL,
    inscricao_estadual character varying(18),
    id_empresa integer NOT NULL
);
    DROP TABLE public.empresas;
       public         heap r       postgres    false         �            1259    440583    empresas_id_empresa_seq    SEQUENCE     �   ALTER TABLE public.empresas ALTER COLUMN id_empresa ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.empresas_id_empresa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    227         �            1259    440584 	   formapgto    TABLE     �   CREATE TABLE public.formapgto (
    id integer NOT NULL,
    id_empresa integer NOT NULL,
    descricao character varying(50),
    id_situacao integer,
    b_venda_web boolean DEFAULT false,
    sfi_codigo integer
);
    DROP TABLE public.formapgto;
       public         heap r       postgres    false         �            1259    440588    grupos    TABLE     �   CREATE TABLE public.grupos (
    codigo integer NOT NULL,
    descricao character varying(60),
    img bytea,
    id_situacao integer DEFAULT 4 NOT NULL,
    id_empresa integer NOT NULL,
    b_exibir_web boolean DEFAULT false NOT NULL
);
    DROP TABLE public.grupos;
       public         heap r       postgres    false         �            1259    440595 
   happy_hour    TABLE     6  CREATE TABLE public.happy_hour (
    id integer NOT NULL,
    idproduto integer NOT NULL,
    idempresa integer NOT NULL,
    horainicial time without time zone NOT NULL,
    horafinal time without time zone NOT NULL,
    segundafeira boolean NOT NULL,
    tercafeira boolean NOT NULL,
    quartafeira boolean NOT NULL,
    quintafeira boolean NOT NULL,
    sextafeira boolean NOT NULL,
    sabado boolean NOT NULL,
    domingo boolean NOT NULL,
    valor numeric(15,3) NOT NULL,
    utiliza_mesa boolean DEFAULT false,
    utiliza_delivery boolean DEFAULT false
);
    DROP TABLE public.happy_hour;
       public         heap r       postgres    false         �            1259    440600    happy_hour_id_seq    SEQUENCE     �   CREATE SEQUENCE public.happy_hour_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.happy_hour_id_seq;
       public               postgres    false    231         R           0    0    happy_hour_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.happy_hour_id_seq OWNED BY public.happy_hour.id;
          public               postgres    false    232         �            1259    440601    mesa    TABLE     �   CREATE TABLE public.mesa (
    mes_001 integer,
    emp_001 integer,
    mes_002 character varying(30),
    mes_003 integer,
    id_situacao integer DEFAULT 4
);
    DROP TABLE public.mesa;
       public         heap r       postgres    false         �            1259    440605    opcional    TABLE     �  CREATE TABLE public.opcional (
    codigo integer NOT NULL,
    id_empresa integer NOT NULL,
    descricao character varying(100) NOT NULL,
    valor numeric(15,2) NOT NULL,
    id_situacao integer DEFAULT 4 NOT NULL,
    opc_p character varying(100),
    opc_m character varying(100),
    opc_g character varying(100),
    opc_extra character varying(100),
    valor_opc_p numeric(15,2) DEFAULT 0.00,
    valor_opc_g numeric(15,2) DEFAULT 0.00,
    valor_opc_m numeric(15,2) DEFAULT 0.00,
    valor_opc_gg numeric(15,2) DEFAULT 0.00,
    valor_opc_extra numeric(15,2) DEFAULT 0.00,
    tipo integer DEFAULT 0 NOT NULL,
    opc_gg character varying(100),
    imagem_db bytea
);
    DROP TABLE public.opcional;
       public         heap r       postgres    false         �            1259    440617    produtos    TABLE     �  CREATE TABLE public.produtos (
    codigo integer NOT NULL,
    descricao character varying(60),
    codigrupo integer,
    valfinal numeric(15,2),
    valcompra numeric(15,2),
    observacao character varying(1200),
    img1 bytea,
    img2 bytea,
    img bytea,
    id_situacao integer DEFAULT 4 NOT NULL,
    id_empresa integer NOT NULL,
    b_venda_web boolean DEFAULT false NOT NULL,
    utiliza_combo boolean DEFAULT false NOT NULL,
    b_destaque_web boolean DEFAULT false,
    b_permite_frac boolean DEFAULT true NOT NULL,
    tamanho_p character varying(100),
    tamanho_m character varying(100),
    tamanho_g character varying(100),
    tamanho_gg character varying(100),
    tamanho_extra character varying(100),
    tamanho_padrao character varying(2) DEFAULT 'M'::character varying,
    valor_tam_p numeric(15,2) DEFAULT 0.00,
    valor_tam_m numeric(15,2) DEFAULT 0.00,
    valor_tam_g numeric(15,2) DEFAULT 0.00,
    valor_tam_gg numeric(15,2) DEFAULT 0.00,
    b_venda_tamanho boolean DEFAULT false,
    valor_tam_extra numeric(15,2) DEFAULT 0.00,
    b_carrossel boolean DEFAULT false,
    utiliza_promocao boolean DEFAULT false,
    b_exporta_peso_balanca boolean DEFAULT false,
    b_peso_balanca boolean DEFAULT false NOT NULL,
    restringirvenda boolean DEFAULT false,
    utiliza_happy_hour boolean DEFAULT false,
    opcional_minimo integer DEFAULT 0,
    opcional_maximo integer DEFAULT 0
);
    DROP TABLE public.produtos;
       public         heap r       postgres    false         �            1259    440642    produtos_opcional    TABLE     �   CREATE TABLE public.produtos_opcional (
    id_empresa integer NOT NULL,
    id_material integer NOT NULL,
    id_opcional integer NOT NULL
);
 %   DROP TABLE public.produtos_opcional;
       public         heap r       postgres    false         �            1259    440645    promocao    TABLE     �
  CREATE TABLE public.promocao (
    id_promocao integer NOT NULL,
    id_empresa integer NOT NULL,
    id_material integer NOT NULL,
    tipo_desconto integer DEFAULT 0 NOT NULL,
    segundafeira boolean DEFAULT false NOT NULL,
    tercafeira boolean DEFAULT false NOT NULL,
    quartafeira boolean DEFAULT false NOT NULL,
    quintafeira boolean DEFAULT false NOT NULL,
    sextafeira boolean DEFAULT false NOT NULL,
    sabado boolean DEFAULT false NOT NULL,
    domingo boolean DEFAULT false NOT NULL,
    tipomesa boolean DEFAULT false NOT NULL,
    tipodelivery boolean DEFAULT false NOT NULL,
    tipocomanda boolean DEFAULT false NOT NULL,
    descontosegundapadrao numeric(15,3) DEFAULT 0,
    descontosegundatamanhop numeric(15,3) DEFAULT 0,
    descontosegundatamanhom numeric(15,3) DEFAULT 0,
    descontosegundatamanhog numeric(15,3) DEFAULT 0,
    descontosegundatamanhogg numeric(15,3) DEFAULT 0,
    descontosegundatamanhoextra numeric(15,3) DEFAULT 0,
    desconto_ter_padrao numeric(15,3) DEFAULT 0,
    desconto_ter_tam_p numeric(15,3) DEFAULT 0,
    desconto_ter_tam_m numeric(15,3) DEFAULT 0,
    desconto_ter_tam_g numeric(15,3) DEFAULT 0,
    desconto_ter_tam_gg numeric(15,3) DEFAULT 0,
    desconto_ter_tam_extra numeric(15,3) DEFAULT 0,
    desconto_qua_padrao numeric(15,3) DEFAULT 0,
    desconto_qua_tam_p numeric(15,3) DEFAULT 0,
    desconto_qua_tam_m numeric(15,3) DEFAULT 0,
    desconto_qua_tam_g numeric(15,3) DEFAULT 0,
    desconto_qua_tam_gg numeric(15,3) DEFAULT 0,
    desconto_qua_tam_extra numeric(15,3) DEFAULT 0,
    desconto_qui_padrao numeric(15,3) DEFAULT 0,
    desconto_qui_tam_p numeric(15,3) DEFAULT 0,
    desconto_qui_tam_m numeric(15,3) DEFAULT 0,
    desconto_qui_tam_g numeric(15,3) DEFAULT 0,
    desconto_qui_tam_gg numeric(15,3) DEFAULT 0,
    desconto_qui_tam_extra numeric(15,3) DEFAULT 0,
    desconto_sex_padrao numeric(15,3) DEFAULT 0,
    desconto_sex_tam_p numeric(15,3) DEFAULT 0,
    desconto_sex_tam_m numeric(15,3) DEFAULT 0,
    desconto_sex_tam_g numeric(15,3) DEFAULT 0,
    desconto_sex_tam_gg numeric(15,3) DEFAULT 0,
    desconto_sex_tam_extra numeric(15,3) DEFAULT 0,
    desconto_sab_padrao numeric(15,3) DEFAULT 0,
    desconto_sab_tam_p numeric(15,3) DEFAULT 0,
    desconto_sab_tam_m numeric(15,3) DEFAULT 0,
    desconto_sab_tam_g numeric(15,3) DEFAULT 0,
    desconto_sab_tam_gg numeric(15,3) DEFAULT 0,
    desconto_sab_tam_extra numeric(15,3) DEFAULT 0,
    desconto_dom_padrao numeric(15,3) DEFAULT 0,
    desconto_dom_tam_p numeric(15,3) DEFAULT 0,
    desconto_dom_tam_m numeric(15,3) DEFAULT 0,
    desconto_dom_tam_g numeric(15,3) DEFAULT 0,
    desconto_dom_tam_gg numeric(15,3) DEFAULT 0,
    desconto_dom_tam_extra numeric(15,3) DEFAULT 0
);
    DROP TABLE public.promocao;
       public         heap r       postgres    false         �            1259    440701    restricoesvendas    TABLE     ^  CREATE TABLE public.restricoesvendas (
    idempresa integer,
    idproduto integer,
    segundafeira boolean DEFAULT false,
    tercafeira boolean DEFAULT false,
    quartafeira boolean DEFAULT false,
    quintafeira boolean DEFAULT false,
    sextafeira boolean DEFAULT false,
    sabado boolean DEFAULT false,
    domingo boolean DEFAULT false
);
 $   DROP TABLE public.restricoesvendas;
       public         heap r       postgres    false         �            1259    440711    sincronizacao    TABLE     �   CREATE TABLE public.sincronizacao (
    id integer NOT NULL,
    data timestamp without time zone NOT NULL,
    id_empresa integer NOT NULL
);
 !   DROP TABLE public.sincronizacao;
       public         heap r       postgres    false         S           0    0    COLUMN sincronizacao.id    COMMENT     D   COMMENT ON COLUMN public.sincronizacao.id IS 'ID de sincronizacao';
          public               postgres    false    239         T           0    0    COLUMN sincronizacao.data    COMMENT     H   COMMENT ON COLUMN public.sincronizacao.data IS 'Data da sincronizacao';
          public               postgres    false    239         U           0    0    COLUMN sincronizacao.id_empresa    COMMENT     F   COMMENT ON COLUMN public.sincronizacao.id_empresa IS 'ID da empresa';
          public               postgres    false    239         �            1259    440714    transferencia_imagens    TABLE     �   CREATE TABLE public.transferencia_imagens (
    id integer NOT NULL,
    tipo character varying(10) NOT NULL,
    id_empresa integer DEFAULT 1 NOT NULL,
    id_registro integer NOT NULL
);
 )   DROP TABLE public.transferencia_imagens;
       public         heap r       postgres    false         �            1259    440718    transferencia_imagens_id_seq    SEQUENCE     �   CREATE SEQUENCE public.transferencia_imagens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.transferencia_imagens_id_seq;
       public               postgres    false    240         V           0    0    transferencia_imagens_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.transferencia_imagens_id_seq OWNED BY public.transferencia_imagens.id;
          public               postgres    false    241         �            1259    440719    usuarios    TABLE     �   CREATE TABLE public.usuarios (
    codigo integer NOT NULL,
    nome character varying(30),
    senha character varying(60),
    email character varying(100),
    id_situacao integer DEFAULT 4 NOT NULL
);
    DROP TABLE public.usuarios;
       public         heap r       postgres    false         �            1259    440723    usuarios_empresa    TABLE     o   CREATE TABLE public.usuarios_empresa (
    codigo_usuario integer NOT NULL,
    id_empresa integer NOT NULL
);
 $   DROP TABLE public.usuarios_empresa;
       public         heap r       postgres    false         �            1259    440726    usuarios_permissoes    TABLE     �   CREATE TABLE public.usuarios_permissoes (
    codigo_usuario integer NOT NULL,
    b_acesso_web boolean DEFAULT false,
    b_admin_web boolean DEFAULT false,
    id_empresa integer DEFAULT 1 NOT NULL
);
 '   DROP TABLE public.usuarios_permissoes;
       public         heap r       postgres    false         �            1259    440732    venda    TABLE     t  CREATE TABLE public.venda (
    id_venda integer NOT NULL,
    id_empresa integer NOT NULL,
    id_situacao integer NOT NULL,
    id_formapgto integer NOT NULL,
    id_cliente integer NOT NULL,
    totals_products numeric(15,2),
    sub_total numeric(15,2),
    taxa_entrega numeric(15,2),
    troco numeric(15,2),
    valor_receber numeric(15,2),
    sales numeric(15,2),
    data_pedido timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    b_recebido_lecheff boolean DEFAULT false NOT NULL,
    tipo_entrega character varying(2) DEFAULT 'D'::character varying NOT NULL,
    observacao character varying(200)
);
    DROP TABLE public.venda;
       public         heap r       postgres    false         �            1259    440738    venda_endereco    TABLE     �  CREATE TABLE public.venda_endereco (
    id_venda integer NOT NULL,
    id_cliente integer NOT NULL,
    id_bairro integer,
    cep character varying(14) NOT NULL,
    logradouro character varying(150) NOT NULL,
    numero character varying(30),
    complemento character varying(150),
    ponto_referencia character varying(150),
    bairro_desc character varying(100),
    id_endereco integer
);
 "   DROP TABLE public.venda_endereco;
       public         heap r       postgres    false         �            1259    440743    venda_id_venda_seq    SEQUENCE     �   ALTER TABLE public.venda ALTER COLUMN id_venda ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.venda_id_venda_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    245         �            1259    440744 	   vendaitem    TABLE       CREATE TABLE public.vendaitem (
    id_venda integer NOT NULL,
    id_empresa integer NOT NULL,
    id_product integer NOT NULL,
    numero_item integer NOT NULL,
    quantidade numeric(15,4) DEFAULT 0 NOT NULL,
    valor_unit_product numeric(15,4) DEFAULT 0 NOT NULL,
    totals_products numeric(15,4) DEFAULT 0 NOT NULL,
    id_situacao integer,
    tamanho character varying(40),
    b_venda_tamanho boolean DEFAULT false,
    item_fracionado integer,
    observacao character varying(150),
    utilizou_happy_hour boolean DEFAULT false
);
    DROP TABLE public.vendaitem;
       public         heap r       postgres    false         �            1259    440752    vendaitemopcional    TABLE       CREATE TABLE public.vendaitemopcional (
    id_venda integer NOT NULL,
    id_empresa integer NOT NULL,
    id_numero_item integer NOT NULL,
    id_opcional integer NOT NULL,
    gratis numeric(15,4) DEFAULT 0 NOT NULL,
    valor numeric(15,4) DEFAULT 0 NOT NULL,
    valorunitario numeric(15,4) DEFAULT 0 NOT NULL,
    valortotal numeric(15,4) DEFAULT 0 NOT NULL,
    quantidade numeric(15,4) DEFAULT 0 NOT NULL,
    quantidade_replicar numeric(15,4) DEFAULT 0 NOT NULL,
    b_recebido_lecheff boolean DEFAULT false
);
 %   DROP TABLE public.vendaitemopcional;
       public         heap r       postgres    false         �            1259    440761 	   vendamesa    TABLE     �  CREATE TABLE public.vendamesa (
    id_venda integer,
    id_empresa integer,
    id_situacao integer,
    totals_products numeric(15,3),
    sub_total numeric(15,3),
    sales numeric(15,3),
    data_pedido timestamp without time zone,
    b_recebido_lecheff boolean DEFAULT false,
    observacao character varying(300),
    numero_mesa integer,
    descricao_mesa character varying(20)
);
    DROP TABLE public.vendamesa;
       public         heap r       postgres    false         �            1259    440765    vendamesaitem    TABLE     }  CREATE TABLE public.vendamesaitem (
    id_venda integer NOT NULL,
    id_empresa integer NOT NULL,
    id_product integer NOT NULL,
    numero_item integer NOT NULL,
    quantidade numeric(15,4) DEFAULT 0 NOT NULL,
    valor_unit_product numeric(15,4) DEFAULT 0 NOT NULL,
    totals_products numeric(15,4) DEFAULT 0 NOT NULL,
    id_situacao integer,
    tamanho character varying(2),
    b_venda_tamanho boolean DEFAULT false,
    item_fracionado integer,
    observacao character varying(150),
    b_recebido_lecheff boolean DEFAULT false,
    utilizou_happy_hour boolean DEFAULT false,
    utilizou_promocao boolean DEFAULT false
);
 !   DROP TABLE public.vendamesaitem;
       public         heap r       postgres    false         �            1259    440775    vendas_status_log    TABLE     �   CREATE TABLE public.vendas_status_log (
    id_venda integer NOT NULL,
    id_empresa integer DEFAULT 1 NOT NULL,
    id_situacao integer NOT NULL,
    data timestamp without time zone
);
 %   DROP TABLE public.vendas_status_log;
       public         heap r       postgres    false         �           2604    440779    configuracao_funcionamento id    DEFAULT     �   ALTER TABLE ONLY public.configuracao_funcionamento ALTER COLUMN id SET DEFAULT nextval('public.configuracao_funcionamento_id_seq'::regclass);
 L   ALTER TABLE public.configuracao_funcionamento ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    224    223         �           2604    440780    configuracao_rpfood id    DEFAULT     �   ALTER TABLE ONLY public.configuracao_rpfood ALTER COLUMN id SET DEFAULT nextval('public.configuracao_rpfood_id_seq'::regclass);
 E   ALTER TABLE public.configuracao_rpfood ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    226    225         �           2604    440781    happy_hour id    DEFAULT     n   ALTER TABLE ONLY public.happy_hour ALTER COLUMN id SET DEFAULT nextval('public.happy_hour_id_seq'::regclass);
 <   ALTER TABLE public.happy_hour ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    232    231         O           2604    440782    transferencia_imagens id    DEFAULT     �   ALTER TABLE ONLY public.transferencia_imagens ALTER COLUMN id SET DEFAULT nextval('public.transferencia_imagens_id_seq'::regclass);
 G   ALTER TABLE public.transferencia_imagens ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    241    240         &          0    440516    bairro 
   TABLE DATA           b   COPY public.bairro (bai_001, emp_001, bai_002, bai_003, sit_001, b_restricao_entrega) FROM stdin;
    public               postgres    false    217       5158.dat '          0    440521    bairro_ceps 
   TABLE DATA           j   COPY public.bairro_ceps (bai_001, emp_001, cep, logradouro, id_cidade, cidade_desc, uf_sigla) FROM stdin;
    public               postgres    false    218       5159.dat (          0    440524    clientes 
   TABLE DATA           �   COPY public.clientes (id_empresa, cli_004, sit_001, observacao, senha_email, pontos_atuais, email, tipo_pessoa, celular1, cli_001, cli_012, cli_002) FROM stdin;
    public               postgres    false    219       5160.dat *          0    440533    clientes_endereco 
   TABLE DATA           �   COPY public.clientes_endereco (id_endereco, cli_001, id_empresa, cep_002, cep_003, cep_004, cli_007, cli_008, cli_009, bai_001, endereco_padrao, taxa, idcidade, uf) FROM stdin;
    public               postgres    false    221       5162.dat ,          0    440540    configuracao_funcionamento 
   TABLE DATA           �  COPY public.configuracao_funcionamento (dia_segunda, dia_terca, dia_quarta, dia_quinta, dia_sexta, dia_sabado, dia_domingo, segunda_inicio_atendimento, terca_inicio_atendimento, quarta_inicio_atendimento, quinta_inicio_atendimento, sexta_inicio_atendimento, sabado_inicio_atendimento, domingo_inicio_atendimento, segunda_fim_atendimento, terca_fim_atendimento, quarta_fim_atendimento, quinta_fim_atendimento, sexta_fim_atendimento, sabado_fim_atendimento, domingo_fim_atendimento, id_empresa, id) FROM stdin;
    public               postgres    false    223       5164.dat .          0    440565    configuracao_rpfood 
   TABLE DATA           �   COPY public.configuracao_rpfood (id_empresa, tempo_retirada_rpfood, tempo_entrega_rpfood, utiliza_tipo_entrega_retirada, modo_acougue, pedido_minimo, id, utiliza_controle_opcionais, utiliza_controle_ceps) FROM stdin;
    public               postgres    false    225       5166.dat 0          0    440577    empresas 
   TABLE DATA           �   COPY public.empresas (descricao, codiuf, codicidade, uf, cidade, bairro, endereco, tipoendereco, nome, razsoc, cnpj, cep, numero, fone1, descrifone1, ddd1, email, site, complemento, id_situacao, inscricao_estadual, id_empresa) FROM stdin;
    public               postgres    false    227       5168.dat 2          0    440584 	   formapgto 
   TABLE DATA           d   COPY public.formapgto (id, id_empresa, descricao, id_situacao, b_venda_web, sfi_codigo) FROM stdin;
    public               postgres    false    229       5170.dat 3          0    440588    grupos 
   TABLE DATA           _   COPY public.grupos (codigo, descricao, img, id_situacao, id_empresa, b_exibir_web) FROM stdin;
    public               postgres    false    230       5171.dat 4          0    440595 
   happy_hour 
   TABLE DATA           �   COPY public.happy_hour (id, idproduto, idempresa, horainicial, horafinal, segundafeira, tercafeira, quartafeira, quintafeira, sextafeira, sabado, domingo, valor, utiliza_mesa, utiliza_delivery) FROM stdin;
    public               postgres    false    231       5172.dat 6          0    440601    mesa 
   TABLE DATA           O   COPY public.mesa (mes_001, emp_001, mes_002, mes_003, id_situacao) FROM stdin;
    public               postgres    false    233       5174.dat 7          0    440605    opcional 
   TABLE DATA           �   COPY public.opcional (codigo, id_empresa, descricao, valor, id_situacao, opc_p, opc_m, opc_g, opc_extra, valor_opc_p, valor_opc_g, valor_opc_m, valor_opc_gg, valor_opc_extra, tipo, opc_gg, imagem_db) FROM stdin;
    public               postgres    false    234       5175.dat 8          0    440617    produtos 
   TABLE DATA           �  COPY public.produtos (codigo, descricao, codigrupo, valfinal, valcompra, observacao, img1, img2, img, id_situacao, id_empresa, b_venda_web, utiliza_combo, b_destaque_web, b_permite_frac, tamanho_p, tamanho_m, tamanho_g, tamanho_gg, tamanho_extra, tamanho_padrao, valor_tam_p, valor_tam_m, valor_tam_g, valor_tam_gg, b_venda_tamanho, valor_tam_extra, b_carrossel, utiliza_promocao, b_exporta_peso_balanca, b_peso_balanca, restringirvenda, utiliza_happy_hour, opcional_minimo, opcional_maximo) FROM stdin;
    public               postgres    false    235       5176.dat 9          0    440642    produtos_opcional 
   TABLE DATA           Q   COPY public.produtos_opcional (id_empresa, id_material, id_opcional) FROM stdin;
    public               postgres    false    236       5177.dat :          0    440645    promocao 
   TABLE DATA           Z  COPY public.promocao (id_promocao, id_empresa, id_material, tipo_desconto, segundafeira, tercafeira, quartafeira, quintafeira, sextafeira, sabado, domingo, tipomesa, tipodelivery, tipocomanda, descontosegundapadrao, descontosegundatamanhop, descontosegundatamanhom, descontosegundatamanhog, descontosegundatamanhogg, descontosegundatamanhoextra, desconto_ter_padrao, desconto_ter_tam_p, desconto_ter_tam_m, desconto_ter_tam_g, desconto_ter_tam_gg, desconto_ter_tam_extra, desconto_qua_padrao, desconto_qua_tam_p, desconto_qua_tam_m, desconto_qua_tam_g, desconto_qua_tam_gg, desconto_qua_tam_extra, desconto_qui_padrao, desconto_qui_tam_p, desconto_qui_tam_m, desconto_qui_tam_g, desconto_qui_tam_gg, desconto_qui_tam_extra, desconto_sex_padrao, desconto_sex_tam_p, desconto_sex_tam_m, desconto_sex_tam_g, desconto_sex_tam_gg, desconto_sex_tam_extra, desconto_sab_padrao, desconto_sab_tam_p, desconto_sab_tam_m, desconto_sab_tam_g, desconto_sab_tam_gg, desconto_sab_tam_extra, desconto_dom_padrao, desconto_dom_tam_p, desconto_dom_tam_m, desconto_dom_tam_g, desconto_dom_tam_gg, desconto_dom_tam_extra) FROM stdin;
    public               postgres    false    237       5178.dat ;          0    440701    restricoesvendas 
   TABLE DATA           �   COPY public.restricoesvendas (idempresa, idproduto, segundafeira, tercafeira, quartafeira, quintafeira, sextafeira, sabado, domingo) FROM stdin;
    public               postgres    false    238       5179.dat <          0    440711    sincronizacao 
   TABLE DATA           =   COPY public.sincronizacao (id, data, id_empresa) FROM stdin;
    public               postgres    false    239       5180.dat =          0    440714    transferencia_imagens 
   TABLE DATA           R   COPY public.transferencia_imagens (id, tipo, id_empresa, id_registro) FROM stdin;
    public               postgres    false    240       5181.dat ?          0    440719    usuarios 
   TABLE DATA           K   COPY public.usuarios (codigo, nome, senha, email, id_situacao) FROM stdin;
    public               postgres    false    242       5183.dat @          0    440723    usuarios_empresa 
   TABLE DATA           F   COPY public.usuarios_empresa (codigo_usuario, id_empresa) FROM stdin;
    public               postgres    false    243       5184.dat A          0    440726    usuarios_permissoes 
   TABLE DATA           d   COPY public.usuarios_permissoes (codigo_usuario, b_acesso_web, b_admin_web, id_empresa) FROM stdin;
    public               postgres    false    244       5185.dat B          0    440732    venda 
   TABLE DATA           �   COPY public.venda (id_venda, id_empresa, id_situacao, id_formapgto, id_cliente, totals_products, sub_total, taxa_entrega, troco, valor_receber, sales, data_pedido, b_recebido_lecheff, tipo_entrega, observacao) FROM stdin;
    public               postgres    false    245       5186.dat C          0    440738    venda_endereco 
   TABLE DATA           �   COPY public.venda_endereco (id_venda, id_cliente, id_bairro, cep, logradouro, numero, complemento, ponto_referencia, bairro_desc, id_endereco) FROM stdin;
    public               postgres    false    246       5187.dat E          0    440744 	   vendaitem 
   TABLE DATA           �   COPY public.vendaitem (id_venda, id_empresa, id_product, numero_item, quantidade, valor_unit_product, totals_products, id_situacao, tamanho, b_venda_tamanho, item_fracionado, observacao, utilizou_happy_hour) FROM stdin;
    public               postgres    false    248       5189.dat F          0    440752    vendaitemopcional 
   TABLE DATA           �   COPY public.vendaitemopcional (id_venda, id_empresa, id_numero_item, id_opcional, gratis, valor, valorunitario, valortotal, quantidade, quantidade_replicar, b_recebido_lecheff) FROM stdin;
    public               postgres    false    249       5190.dat G          0    440761 	   vendamesa 
   TABLE DATA           �   COPY public.vendamesa (id_venda, id_empresa, id_situacao, totals_products, sub_total, sales, data_pedido, b_recebido_lecheff, observacao, numero_mesa, descricao_mesa) FROM stdin;
    public               postgres    false    250       5191.dat H          0    440765    vendamesaitem 
   TABLE DATA             COPY public.vendamesaitem (id_venda, id_empresa, id_product, numero_item, quantidade, valor_unit_product, totals_products, id_situacao, tamanho, b_venda_tamanho, item_fracionado, observacao, b_recebido_lecheff, utilizou_happy_hour, utilizou_promocao) FROM stdin;
    public               postgres    false    251       5192.dat I          0    440775    vendas_status_log 
   TABLE DATA           T   COPY public.vendas_status_log (id_venda, id_empresa, id_situacao, data) FROM stdin;
    public               postgres    false    252       5193.dat W           0    0    clientes_cli_001_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.clientes_cli_001_seq', 1, true);
          public               postgres    false    220         X           0    0 !   clientes_endereco_id_endereco_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.clientes_endereco_id_endereco_seq', 1, false);
          public               postgres    false    222         Y           0    0 !   configuracao_funcionamento_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.configuracao_funcionamento_id_seq', 1, false);
          public               postgres    false    224         Z           0    0    configuracao_rpfood_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.configuracao_rpfood_id_seq', 1, false);
          public               postgres    false    226         [           0    0    empresas_id_empresa_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.empresas_id_empresa_seq', 1, true);
          public               postgres    false    228         \           0    0    happy_hour_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.happy_hour_id_seq', 24, true);
          public               postgres    false    232         ]           0    0    transferencia_imagens_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.transferencia_imagens_id_seq', 9407, true);
          public               postgres    false    241         ^           0    0    venda_id_venda_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.venda_id_venda_seq', 1, false);
          public               postgres    false    247         t           2606    441031 :   configuracao_funcionamento configuracao_funcionamento_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.configuracao_funcionamento
    ADD CONSTRAINT configuracao_funcionamento_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.configuracao_funcionamento DROP CONSTRAINT configuracao_funcionamento_pkey;
       public                 postgres    false    223         v           2606    441033 ,   configuracao_rpfood configuracao_rpfood_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.configuracao_rpfood
    ADD CONSTRAINT configuracao_rpfood_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.configuracao_rpfood DROP CONSTRAINT configuracao_rpfood_pkey;
       public                 postgres    false    225         x           2606    441035    empresas empresas_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.empresas
    ADD CONSTRAINT empresas_pkey PRIMARY KEY (id_empresa);
 @   ALTER TABLE ONLY public.empresas DROP CONSTRAINT empresas_pkey;
       public                 postgres    false    227         z           2606    441037    formapgto formapgto_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.formapgto
    ADD CONSTRAINT formapgto_pkey PRIMARY KEY (id, id_empresa);
 B   ALTER TABLE ONLY public.formapgto DROP CONSTRAINT formapgto_pkey;
       public                 postgres    false    229    229         |           2606    441039    grupos grupos_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.grupos
    ADD CONSTRAINT grupos_pkey PRIMARY KEY (codigo, id_empresa);
 <   ALTER TABLE ONLY public.grupos DROP CONSTRAINT grupos_pkey;
       public                 postgres    false    230    230         ~           2606    441041    happy_hour happy_hour_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.happy_hour
    ADD CONSTRAINT happy_hour_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.happy_hour DROP CONSTRAINT happy_hour_pkey;
       public                 postgres    false    231         �           2606    441043    opcional opcional_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.opcional
    ADD CONSTRAINT opcional_pkey PRIMARY KEY (codigo, id_empresa);
 @   ALTER TABLE ONLY public.opcional DROP CONSTRAINT opcional_pkey;
       public                 postgres    false    234    234         n           2606    441045    bairro pk_bairro 
   CONSTRAINT     \   ALTER TABLE ONLY public.bairro
    ADD CONSTRAINT pk_bairro PRIMARY KEY (bai_001, emp_001);
 :   ALTER TABLE ONLY public.bairro DROP CONSTRAINT pk_bairro;
       public                 postgres    false    217    217         p           2606    441047    bairro_ceps pk_bairro_ceps 
   CONSTRAINT     k   ALTER TABLE ONLY public.bairro_ceps
    ADD CONSTRAINT pk_bairro_ceps PRIMARY KEY (bai_001, emp_001, cep);
 D   ALTER TABLE ONLY public.bairro_ceps DROP CONSTRAINT pk_bairro_ceps;
       public                 postgres    false    218    218    218         r           2606    441049 &   clientes_endereco pk_clientes_endereco 
   CONSTRAINT     y   ALTER TABLE ONLY public.clientes_endereco
    ADD CONSTRAINT pk_clientes_endereco PRIMARY KEY (id_endereco, id_empresa);
 P   ALTER TABLE ONLY public.clientes_endereco DROP CONSTRAINT pk_clientes_endereco;
       public                 postgres    false    221    221         �           2606    441051    promocao pk_promocao 
   CONSTRAINT     g   ALTER TABLE ONLY public.promocao
    ADD CONSTRAINT pk_promocao PRIMARY KEY (id_promocao, id_empresa);
 >   ALTER TABLE ONLY public.promocao DROP CONSTRAINT pk_promocao;
       public                 postgres    false    237    237         �           2606    441053    usuarios pk_usuarios 
   CONSTRAINT     V   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT pk_usuarios PRIMARY KEY (codigo);
 >   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT pk_usuarios;
       public                 postgres    false    242         �           2606    441055 $   usuarios_empresa pk_usuarios_empresa 
   CONSTRAINT     z   ALTER TABLE ONLY public.usuarios_empresa
    ADD CONSTRAINT pk_usuarios_empresa PRIMARY KEY (codigo_usuario, id_empresa);
 N   ALTER TABLE ONLY public.usuarios_empresa DROP CONSTRAINT pk_usuarios_empresa;
       public                 postgres    false    243    243         �           2606    441057    venda pk_venda 
   CONSTRAINT     ^   ALTER TABLE ONLY public.venda
    ADD CONSTRAINT pk_venda PRIMARY KEY (id_venda, id_empresa);
 8   ALTER TABLE ONLY public.venda DROP CONSTRAINT pk_venda;
       public                 postgres    false    245    245         �           2606    441059    vendaitem pk_vendaitem 
   CONSTRAINT     s   ALTER TABLE ONLY public.vendaitem
    ADD CONSTRAINT pk_vendaitem PRIMARY KEY (id_venda, id_empresa, numero_item);
 @   ALTER TABLE ONLY public.vendaitem DROP CONSTRAINT pk_vendaitem;
       public                 postgres    false    248    248    248         �           2606    441061    vendamesaitem pk_vendamesaitem 
   CONSTRAINT     {   ALTER TABLE ONLY public.vendamesaitem
    ADD CONSTRAINT pk_vendamesaitem PRIMARY KEY (id_venda, id_empresa, numero_item);
 H   ALTER TABLE ONLY public.vendamesaitem DROP CONSTRAINT pk_vendamesaitem;
       public                 postgres    false    251    251    251         �           2606    441063    produtos produtos_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (codigo, id_empresa);
 @   ALTER TABLE ONLY public.produtos DROP CONSTRAINT produtos_pkey;
       public                 postgres    false    235    235         �           2606    441065 "   venda_endereco venda_endereco_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.venda_endereco
    ADD CONSTRAINT venda_endereco_pkey PRIMARY KEY (id_venda, id_cliente);
 L   ALTER TABLE ONLY public.venda_endereco DROP CONSTRAINT venda_endereco_pkey;
       public                 postgres    false    246    246         �           2606    441066    bairro_ceps fk_bairro_ceps    FK CONSTRAINT     �   ALTER TABLE ONLY public.bairro_ceps
    ADD CONSTRAINT fk_bairro_ceps FOREIGN KEY (bai_001, emp_001) REFERENCES public.bairro(bai_001, emp_001) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.bairro_ceps DROP CONSTRAINT fk_bairro_ceps;
       public               postgres    false    217    218    218    4974    217         �           2606    441071    formapgto fk_formapgto_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.formapgto
    ADD CONSTRAINT fk_formapgto_id FOREIGN KEY (id_empresa) REFERENCES public.empresas(id_empresa) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.formapgto DROP CONSTRAINT fk_formapgto_id;
       public               postgres    false    229    227    4984         �           2606    441076    promocao fk_promocao_idmaterial    FK CONSTRAINT     �   ALTER TABLE ONLY public.promocao
    ADD CONSTRAINT fk_promocao_idmaterial FOREIGN KEY (id_material, id_empresa) REFERENCES public.produtos(codigo, id_empresa) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.promocao DROP CONSTRAINT fk_promocao_idmaterial;
       public               postgres    false    235    235    237    237    4994         �           2606    441081    vendaitem fk_venda_item_empresa    FK CONSTRAINT     �   ALTER TABLE ONLY public.vendaitem
    ADD CONSTRAINT fk_venda_item_empresa FOREIGN KEY (id_empresa) REFERENCES public.empresas(id_empresa) ON UPDATE CASCADE ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.vendaitem DROP CONSTRAINT fk_venda_item_empresa;
       public               postgres    false    4984    248    227                                                                                                                                5158.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014277 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5159.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014300 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5160.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014270 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5162.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014272 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5164.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014274 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5166.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014276 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5168.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014300 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5170.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014271 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5171.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014272 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5172.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014273 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5174.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014275 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5175.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014276 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5176.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014277 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5177.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014300 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5178.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014301 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5179.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014302 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5180.dat                                                                                            0000600 0004000 0002000 00000000044 14757377176 0014275 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	2025-02-25 14:31:30.057584	1
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            5181.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014273 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5183.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014275 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5184.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014276 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5185.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014277 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5186.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014300 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5187.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014301 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5189.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014303 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5190.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014273 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5191.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014274 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5192.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014275 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5193.dat                                                                                            0000600 0004000 0002000 00000000005 14757377176 0014276 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           restore.sql                                                                                         0000600 0004000 0002000 00000136021 14757377176 0015417 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE "FOOD";
--
-- Name: FOOD; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "FOOD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';


ALTER DATABASE "FOOD" OWNER TO postgres;

\connect "FOOD"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: is_atendimento_disponivel(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_atendimento_disponivel() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    atendimento_disponivel BOOLEAN := false;
    config configuracao_funcionamento%ROWTYPE;
    current_day_of_week INTEGER;
    current_local_time TIME;
BEGIN
    -- Obter o dia da semana atual (0 para domingo, 1 para segunda-feira, 2 para terça-feira, etc.)
    current_day_of_week := EXTRACT(DOW FROM CURRENT_DATE)::INTEGER;

    -- Obter o horário atual em 'America/Sao_Paulo'
    current_local_time := (SELECT Current_Time at time zone 'America/Sao_Paulo');

    -- Obter as configurações de atendimento
    SELECT * INTO config FROM configuracao_funcionamento LIMIT 1;

    -- Verificar se o atendimento está disponível no dia da semana atual
    CASE current_day_of_week
        WHEN 1 THEN
            atendimento_disponivel := config.dia_segunda AND
                current_local_time >= config.segunda_inicio_atendimento AND
                current_local_time <= config.segunda_fim_atendimento;
        WHEN 2 THEN
            atendimento_disponivel := config.dia_terca AND
                current_local_time >= config.terca_inicio_atendimento AND
                current_local_time <= config.terca_fim_atendimento;
        WHEN 3 THEN
            atendimento_disponivel := config.dia_quarta AND
                current_local_time >= config.quarta_inicio_atendimento AND
                current_local_time <= config.quarta_fim_atendimento;
        WHEN 4 THEN
            atendimento_disponivel := config.dia_quinta AND
                current_local_time >= config.quinta_inicio_atendimento AND
                current_local_time <= config.quinta_fim_atendimento;
        WHEN 5 THEN
            atendimento_disponivel := config.dia_sexta AND
                current_local_time >= config.sexta_inicio_atendimento AND
                current_local_time <= config.sexta_fim_atendimento;
        WHEN 6 THEN
            atendimento_disponivel := config.dia_sabado AND
                current_local_time >= config.sabado_inicio_atendimento AND
                current_local_time <= config.sabado_fim_atendimento;
        WHEN 0 THEN
            atendimento_disponivel := config.dia_domingo AND
                current_local_time >= config.domingo_inicio_atendimento AND
                current_local_time <= config.domingo_fim_atendimento;
    END CASE;

    RETURN atendimento_disponivel;
END;
$$;


ALTER FUNCTION public.is_atendimento_disponivel() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bairro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bairro (
    bai_001 integer NOT NULL,
    emp_001 integer NOT NULL,
    bai_002 character varying(60) NOT NULL,
    bai_003 numeric(15,2),
    sit_001 integer DEFAULT 4 NOT NULL,
    b_restricao_entrega boolean DEFAULT false NOT NULL
);


ALTER TABLE public.bairro OWNER TO postgres;

--
-- Name: bairro_ceps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bairro_ceps (
    bai_001 integer NOT NULL,
    emp_001 integer NOT NULL,
    cep character varying(9) NOT NULL,
    logradouro character varying(125),
    id_cidade integer,
    cidade_desc character varying(75),
    uf_sigla character varying(2)
);


ALTER TABLE public.bairro_ceps OWNER TO postgres;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    id_empresa integer DEFAULT 1 NOT NULL,
    cli_004 character varying(20),
    sit_001 integer DEFAULT 4 NOT NULL,
    observacao text,
    senha_email character varying(100),
    pontos_atuais integer,
    email character varying(100),
    tipo_pessoa character varying(1) DEFAULT 'F'::character varying,
    celular1 character varying(30),
    cli_001 integer NOT NULL,
    cli_012 character varying(50),
    cli_002 character varying(100)
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- Name: clientes_cli_001_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.clientes ALTER COLUMN cli_001 ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.clientes_cli_001_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: clientes_endereco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes_endereco (
    id_endereco integer NOT NULL,
    cli_001 integer NOT NULL,
    id_empresa integer NOT NULL,
    cep_002 character varying(9),
    cep_003 character varying(50),
    cep_004 character varying(125),
    cli_007 character varying(80),
    cli_008 character varying(100),
    cli_009 character varying(100),
    bai_001 integer,
    endereco_padrao boolean DEFAULT false,
    taxa numeric(15,3),
    idcidade integer,
    uf character varying(50)
);


ALTER TABLE public.clientes_endereco OWNER TO postgres;

--
-- Name: clientes_endereco_id_endereco_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.clientes_endereco ALTER COLUMN id_endereco ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.clientes_endereco_id_endereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: configuracao_funcionamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.configuracao_funcionamento (
    dia_segunda boolean DEFAULT false NOT NULL,
    dia_terca boolean DEFAULT false NOT NULL,
    dia_quarta boolean DEFAULT false NOT NULL,
    dia_quinta boolean DEFAULT false NOT NULL,
    dia_sexta boolean DEFAULT false NOT NULL,
    dia_sabado boolean DEFAULT false NOT NULL,
    dia_domingo boolean DEFAULT false NOT NULL,
    segunda_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    terca_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    quarta_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    quinta_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    sexta_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    sabado_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    domingo_inicio_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    segunda_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    terca_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    quarta_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    quinta_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    sexta_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    sabado_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    domingo_fim_atendimento time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    id_empresa integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.configuracao_funcionamento OWNER TO postgres;

--
-- Name: configuracao_funcionamento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.configuracao_funcionamento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.configuracao_funcionamento_id_seq OWNER TO postgres;

--
-- Name: configuracao_funcionamento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.configuracao_funcionamento_id_seq OWNED BY public.configuracao_funcionamento.id;


--
-- Name: configuracao_rpfood; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.configuracao_rpfood (
    id_empresa integer DEFAULT 1 NOT NULL,
    tempo_retirada_rpfood integer DEFAULT 0 NOT NULL,
    tempo_entrega_rpfood integer DEFAULT 0 NOT NULL,
    utiliza_tipo_entrega_retirada boolean DEFAULT true,
    modo_acougue boolean DEFAULT false NOT NULL,
    pedido_minimo numeric(15,2) DEFAULT 0.00 NOT NULL,
    id integer NOT NULL,
    utiliza_controle_opcionais boolean DEFAULT false,
    utiliza_controle_ceps boolean DEFAULT true
);


ALTER TABLE public.configuracao_rpfood OWNER TO postgres;

--
-- Name: configuracao_rpfood_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.configuracao_rpfood_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.configuracao_rpfood_id_seq OWNER TO postgres;

--
-- Name: configuracao_rpfood_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.configuracao_rpfood_id_seq OWNED BY public.configuracao_rpfood.id;


--
-- Name: empresas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empresas (
    descricao character varying(40),
    codiuf integer,
    codicidade integer,
    uf character varying(2),
    cidade character varying(30),
    bairro character varying(30),
    endereco character varying(60),
    tipoendereco character varying(30),
    nome character varying(60),
    razsoc character varying(60),
    cnpj character varying(18),
    cep character varying(20),
    numero character varying(20),
    fone1 character varying(30),
    descrifone1 character varying(20),
    ddd1 character(3),
    email character varying(100),
    site character varying(100),
    complemento character varying(100),
    id_situacao integer DEFAULT 4 NOT NULL,
    inscricao_estadual character varying(18),
    id_empresa integer NOT NULL
);


ALTER TABLE public.empresas OWNER TO postgres;

--
-- Name: empresas_id_empresa_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.empresas ALTER COLUMN id_empresa ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.empresas_id_empresa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: formapgto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.formapgto (
    id integer NOT NULL,
    id_empresa integer NOT NULL,
    descricao character varying(50),
    id_situacao integer,
    b_venda_web boolean DEFAULT false,
    sfi_codigo integer
);


ALTER TABLE public.formapgto OWNER TO postgres;

--
-- Name: grupos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grupos (
    codigo integer NOT NULL,
    descricao character varying(60),
    img bytea,
    id_situacao integer DEFAULT 4 NOT NULL,
    id_empresa integer NOT NULL,
    b_exibir_web boolean DEFAULT false NOT NULL
);


ALTER TABLE public.grupos OWNER TO postgres;

--
-- Name: happy_hour; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.happy_hour (
    id integer NOT NULL,
    idproduto integer NOT NULL,
    idempresa integer NOT NULL,
    horainicial time without time zone NOT NULL,
    horafinal time without time zone NOT NULL,
    segundafeira boolean NOT NULL,
    tercafeira boolean NOT NULL,
    quartafeira boolean NOT NULL,
    quintafeira boolean NOT NULL,
    sextafeira boolean NOT NULL,
    sabado boolean NOT NULL,
    domingo boolean NOT NULL,
    valor numeric(15,3) NOT NULL,
    utiliza_mesa boolean DEFAULT false,
    utiliza_delivery boolean DEFAULT false
);


ALTER TABLE public.happy_hour OWNER TO postgres;

--
-- Name: happy_hour_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.happy_hour_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.happy_hour_id_seq OWNER TO postgres;

--
-- Name: happy_hour_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.happy_hour_id_seq OWNED BY public.happy_hour.id;


--
-- Name: mesa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mesa (
    mes_001 integer,
    emp_001 integer,
    mes_002 character varying(30),
    mes_003 integer,
    id_situacao integer DEFAULT 4
);


ALTER TABLE public.mesa OWNER TO postgres;

--
-- Name: opcional; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.opcional (
    codigo integer NOT NULL,
    id_empresa integer NOT NULL,
    descricao character varying(100) NOT NULL,
    valor numeric(15,2) NOT NULL,
    id_situacao integer DEFAULT 4 NOT NULL,
    opc_p character varying(100),
    opc_m character varying(100),
    opc_g character varying(100),
    opc_extra character varying(100),
    valor_opc_p numeric(15,2) DEFAULT 0.00,
    valor_opc_g numeric(15,2) DEFAULT 0.00,
    valor_opc_m numeric(15,2) DEFAULT 0.00,
    valor_opc_gg numeric(15,2) DEFAULT 0.00,
    valor_opc_extra numeric(15,2) DEFAULT 0.00,
    tipo integer DEFAULT 0 NOT NULL,
    opc_gg character varying(100),
    imagem_db bytea
);


ALTER TABLE public.opcional OWNER TO postgres;

--
-- Name: produtos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produtos (
    codigo integer NOT NULL,
    descricao character varying(60),
    codigrupo integer,
    valfinal numeric(15,2),
    valcompra numeric(15,2),
    observacao character varying(1200),
    img1 bytea,
    img2 bytea,
    img bytea,
    id_situacao integer DEFAULT 4 NOT NULL,
    id_empresa integer NOT NULL,
    b_venda_web boolean DEFAULT false NOT NULL,
    utiliza_combo boolean DEFAULT false NOT NULL,
    b_destaque_web boolean DEFAULT false,
    b_permite_frac boolean DEFAULT true NOT NULL,
    tamanho_p character varying(100),
    tamanho_m character varying(100),
    tamanho_g character varying(100),
    tamanho_gg character varying(100),
    tamanho_extra character varying(100),
    tamanho_padrao character varying(2) DEFAULT 'M'::character varying,
    valor_tam_p numeric(15,2) DEFAULT 0.00,
    valor_tam_m numeric(15,2) DEFAULT 0.00,
    valor_tam_g numeric(15,2) DEFAULT 0.00,
    valor_tam_gg numeric(15,2) DEFAULT 0.00,
    b_venda_tamanho boolean DEFAULT false,
    valor_tam_extra numeric(15,2) DEFAULT 0.00,
    b_carrossel boolean DEFAULT false,
    utiliza_promocao boolean DEFAULT false,
    b_exporta_peso_balanca boolean DEFAULT false,
    b_peso_balanca boolean DEFAULT false NOT NULL,
    restringirvenda boolean DEFAULT false,
    utiliza_happy_hour boolean DEFAULT false,
    opcional_minimo integer DEFAULT 0,
    opcional_maximo integer DEFAULT 0
);


ALTER TABLE public.produtos OWNER TO postgres;

--
-- Name: produtos_opcional; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produtos_opcional (
    id_empresa integer NOT NULL,
    id_material integer NOT NULL,
    id_opcional integer NOT NULL
);


ALTER TABLE public.produtos_opcional OWNER TO postgres;

--
-- Name: promocao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promocao (
    id_promocao integer NOT NULL,
    id_empresa integer NOT NULL,
    id_material integer NOT NULL,
    tipo_desconto integer DEFAULT 0 NOT NULL,
    segundafeira boolean DEFAULT false NOT NULL,
    tercafeira boolean DEFAULT false NOT NULL,
    quartafeira boolean DEFAULT false NOT NULL,
    quintafeira boolean DEFAULT false NOT NULL,
    sextafeira boolean DEFAULT false NOT NULL,
    sabado boolean DEFAULT false NOT NULL,
    domingo boolean DEFAULT false NOT NULL,
    tipomesa boolean DEFAULT false NOT NULL,
    tipodelivery boolean DEFAULT false NOT NULL,
    tipocomanda boolean DEFAULT false NOT NULL,
    descontosegundapadrao numeric(15,3) DEFAULT 0,
    descontosegundatamanhop numeric(15,3) DEFAULT 0,
    descontosegundatamanhom numeric(15,3) DEFAULT 0,
    descontosegundatamanhog numeric(15,3) DEFAULT 0,
    descontosegundatamanhogg numeric(15,3) DEFAULT 0,
    descontosegundatamanhoextra numeric(15,3) DEFAULT 0,
    desconto_ter_padrao numeric(15,3) DEFAULT 0,
    desconto_ter_tam_p numeric(15,3) DEFAULT 0,
    desconto_ter_tam_m numeric(15,3) DEFAULT 0,
    desconto_ter_tam_g numeric(15,3) DEFAULT 0,
    desconto_ter_tam_gg numeric(15,3) DEFAULT 0,
    desconto_ter_tam_extra numeric(15,3) DEFAULT 0,
    desconto_qua_padrao numeric(15,3) DEFAULT 0,
    desconto_qua_tam_p numeric(15,3) DEFAULT 0,
    desconto_qua_tam_m numeric(15,3) DEFAULT 0,
    desconto_qua_tam_g numeric(15,3) DEFAULT 0,
    desconto_qua_tam_gg numeric(15,3) DEFAULT 0,
    desconto_qua_tam_extra numeric(15,3) DEFAULT 0,
    desconto_qui_padrao numeric(15,3) DEFAULT 0,
    desconto_qui_tam_p numeric(15,3) DEFAULT 0,
    desconto_qui_tam_m numeric(15,3) DEFAULT 0,
    desconto_qui_tam_g numeric(15,3) DEFAULT 0,
    desconto_qui_tam_gg numeric(15,3) DEFAULT 0,
    desconto_qui_tam_extra numeric(15,3) DEFAULT 0,
    desconto_sex_padrao numeric(15,3) DEFAULT 0,
    desconto_sex_tam_p numeric(15,3) DEFAULT 0,
    desconto_sex_tam_m numeric(15,3) DEFAULT 0,
    desconto_sex_tam_g numeric(15,3) DEFAULT 0,
    desconto_sex_tam_gg numeric(15,3) DEFAULT 0,
    desconto_sex_tam_extra numeric(15,3) DEFAULT 0,
    desconto_sab_padrao numeric(15,3) DEFAULT 0,
    desconto_sab_tam_p numeric(15,3) DEFAULT 0,
    desconto_sab_tam_m numeric(15,3) DEFAULT 0,
    desconto_sab_tam_g numeric(15,3) DEFAULT 0,
    desconto_sab_tam_gg numeric(15,3) DEFAULT 0,
    desconto_sab_tam_extra numeric(15,3) DEFAULT 0,
    desconto_dom_padrao numeric(15,3) DEFAULT 0,
    desconto_dom_tam_p numeric(15,3) DEFAULT 0,
    desconto_dom_tam_m numeric(15,3) DEFAULT 0,
    desconto_dom_tam_g numeric(15,3) DEFAULT 0,
    desconto_dom_tam_gg numeric(15,3) DEFAULT 0,
    desconto_dom_tam_extra numeric(15,3) DEFAULT 0
);


ALTER TABLE public.promocao OWNER TO postgres;

--
-- Name: restricoesvendas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restricoesvendas (
    idempresa integer,
    idproduto integer,
    segundafeira boolean DEFAULT false,
    tercafeira boolean DEFAULT false,
    quartafeira boolean DEFAULT false,
    quintafeira boolean DEFAULT false,
    sextafeira boolean DEFAULT false,
    sabado boolean DEFAULT false,
    domingo boolean DEFAULT false
);


ALTER TABLE public.restricoesvendas OWNER TO postgres;

--
-- Name: sincronizacao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sincronizacao (
    id integer NOT NULL,
    data timestamp without time zone NOT NULL,
    id_empresa integer NOT NULL
);


ALTER TABLE public.sincronizacao OWNER TO postgres;

--
-- Name: COLUMN sincronizacao.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sincronizacao.id IS 'ID de sincronizacao';


--
-- Name: COLUMN sincronizacao.data; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sincronizacao.data IS 'Data da sincronizacao';


--
-- Name: COLUMN sincronizacao.id_empresa; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.sincronizacao.id_empresa IS 'ID da empresa';


--
-- Name: transferencia_imagens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transferencia_imagens (
    id integer NOT NULL,
    tipo character varying(10) NOT NULL,
    id_empresa integer DEFAULT 1 NOT NULL,
    id_registro integer NOT NULL
);


ALTER TABLE public.transferencia_imagens OWNER TO postgres;

--
-- Name: transferencia_imagens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transferencia_imagens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transferencia_imagens_id_seq OWNER TO postgres;

--
-- Name: transferencia_imagens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transferencia_imagens_id_seq OWNED BY public.transferencia_imagens.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    codigo integer NOT NULL,
    nome character varying(30),
    senha character varying(60),
    email character varying(100),
    id_situacao integer DEFAULT 4 NOT NULL
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios_empresa (
    codigo_usuario integer NOT NULL,
    id_empresa integer NOT NULL
);


ALTER TABLE public.usuarios_empresa OWNER TO postgres;

--
-- Name: usuarios_permissoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios_permissoes (
    codigo_usuario integer NOT NULL,
    b_acesso_web boolean DEFAULT false,
    b_admin_web boolean DEFAULT false,
    id_empresa integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.usuarios_permissoes OWNER TO postgres;

--
-- Name: venda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venda (
    id_venda integer NOT NULL,
    id_empresa integer NOT NULL,
    id_situacao integer NOT NULL,
    id_formapgto integer NOT NULL,
    id_cliente integer NOT NULL,
    totals_products numeric(15,2),
    sub_total numeric(15,2),
    taxa_entrega numeric(15,2),
    troco numeric(15,2),
    valor_receber numeric(15,2),
    sales numeric(15,2),
    data_pedido timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    b_recebido_lecheff boolean DEFAULT false NOT NULL,
    tipo_entrega character varying(2) DEFAULT 'D'::character varying NOT NULL,
    observacao character varying(200)
);


ALTER TABLE public.venda OWNER TO postgres;

--
-- Name: venda_endereco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venda_endereco (
    id_venda integer NOT NULL,
    id_cliente integer NOT NULL,
    id_bairro integer,
    cep character varying(14) NOT NULL,
    logradouro character varying(150) NOT NULL,
    numero character varying(30),
    complemento character varying(150),
    ponto_referencia character varying(150),
    bairro_desc character varying(100),
    id_endereco integer
);


ALTER TABLE public.venda_endereco OWNER TO postgres;

--
-- Name: venda_id_venda_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.venda ALTER COLUMN id_venda ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.venda_id_venda_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: vendaitem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendaitem (
    id_venda integer NOT NULL,
    id_empresa integer NOT NULL,
    id_product integer NOT NULL,
    numero_item integer NOT NULL,
    quantidade numeric(15,4) DEFAULT 0 NOT NULL,
    valor_unit_product numeric(15,4) DEFAULT 0 NOT NULL,
    totals_products numeric(15,4) DEFAULT 0 NOT NULL,
    id_situacao integer,
    tamanho character varying(40),
    b_venda_tamanho boolean DEFAULT false,
    item_fracionado integer,
    observacao character varying(150),
    utilizou_happy_hour boolean DEFAULT false
);


ALTER TABLE public.vendaitem OWNER TO postgres;

--
-- Name: vendaitemopcional; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendaitemopcional (
    id_venda integer NOT NULL,
    id_empresa integer NOT NULL,
    id_numero_item integer NOT NULL,
    id_opcional integer NOT NULL,
    gratis numeric(15,4) DEFAULT 0 NOT NULL,
    valor numeric(15,4) DEFAULT 0 NOT NULL,
    valorunitario numeric(15,4) DEFAULT 0 NOT NULL,
    valortotal numeric(15,4) DEFAULT 0 NOT NULL,
    quantidade numeric(15,4) DEFAULT 0 NOT NULL,
    quantidade_replicar numeric(15,4) DEFAULT 0 NOT NULL,
    b_recebido_lecheff boolean DEFAULT false
);


ALTER TABLE public.vendaitemopcional OWNER TO postgres;

--
-- Name: vendamesa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendamesa (
    id_venda integer,
    id_empresa integer,
    id_situacao integer,
    totals_products numeric(15,3),
    sub_total numeric(15,3),
    sales numeric(15,3),
    data_pedido timestamp without time zone,
    b_recebido_lecheff boolean DEFAULT false,
    observacao character varying(300),
    numero_mesa integer,
    descricao_mesa character varying(20)
);


ALTER TABLE public.vendamesa OWNER TO postgres;

--
-- Name: vendamesaitem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendamesaitem (
    id_venda integer NOT NULL,
    id_empresa integer NOT NULL,
    id_product integer NOT NULL,
    numero_item integer NOT NULL,
    quantidade numeric(15,4) DEFAULT 0 NOT NULL,
    valor_unit_product numeric(15,4) DEFAULT 0 NOT NULL,
    totals_products numeric(15,4) DEFAULT 0 NOT NULL,
    id_situacao integer,
    tamanho character varying(2),
    b_venda_tamanho boolean DEFAULT false,
    item_fracionado integer,
    observacao character varying(150),
    b_recebido_lecheff boolean DEFAULT false,
    utilizou_happy_hour boolean DEFAULT false,
    utilizou_promocao boolean DEFAULT false
);


ALTER TABLE public.vendamesaitem OWNER TO postgres;

--
-- Name: vendas_status_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendas_status_log (
    id_venda integer NOT NULL,
    id_empresa integer DEFAULT 1 NOT NULL,
    id_situacao integer NOT NULL,
    data timestamp without time zone
);


ALTER TABLE public.vendas_status_log OWNER TO postgres;

--
-- Name: configuracao_funcionamento id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuracao_funcionamento ALTER COLUMN id SET DEFAULT nextval('public.configuracao_funcionamento_id_seq'::regclass);


--
-- Name: configuracao_rpfood id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuracao_rpfood ALTER COLUMN id SET DEFAULT nextval('public.configuracao_rpfood_id_seq'::regclass);


--
-- Name: happy_hour id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.happy_hour ALTER COLUMN id SET DEFAULT nextval('public.happy_hour_id_seq'::regclass);


--
-- Name: transferencia_imagens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transferencia_imagens ALTER COLUMN id SET DEFAULT nextval('public.transferencia_imagens_id_seq'::regclass);


--
-- Data for Name: bairro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bairro (bai_001, emp_001, bai_002, bai_003, sit_001, b_restricao_entrega) FROM stdin;
\.
COPY public.bairro (bai_001, emp_001, bai_002, bai_003, sit_001, b_restricao_entrega) FROM '$$PATH$$/5158.dat';

--
-- Data for Name: bairro_ceps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bairro_ceps (bai_001, emp_001, cep, logradouro, id_cidade, cidade_desc, uf_sigla) FROM stdin;
\.
COPY public.bairro_ceps (bai_001, emp_001, cep, logradouro, id_cidade, cidade_desc, uf_sigla) FROM '$$PATH$$/5159.dat';

--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes (id_empresa, cli_004, sit_001, observacao, senha_email, pontos_atuais, email, tipo_pessoa, celular1, cli_001, cli_012, cli_002) FROM stdin;
\.
COPY public.clientes (id_empresa, cli_004, sit_001, observacao, senha_email, pontos_atuais, email, tipo_pessoa, celular1, cli_001, cli_012, cli_002) FROM '$$PATH$$/5160.dat';

--
-- Data for Name: clientes_endereco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes_endereco (id_endereco, cli_001, id_empresa, cep_002, cep_003, cep_004, cli_007, cli_008, cli_009, bai_001, endereco_padrao, taxa, idcidade, uf) FROM stdin;
\.
COPY public.clientes_endereco (id_endereco, cli_001, id_empresa, cep_002, cep_003, cep_004, cli_007, cli_008, cli_009, bai_001, endereco_padrao, taxa, idcidade, uf) FROM '$$PATH$$/5162.dat';

--
-- Data for Name: configuracao_funcionamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.configuracao_funcionamento (dia_segunda, dia_terca, dia_quarta, dia_quinta, dia_sexta, dia_sabado, dia_domingo, segunda_inicio_atendimento, terca_inicio_atendimento, quarta_inicio_atendimento, quinta_inicio_atendimento, sexta_inicio_atendimento, sabado_inicio_atendimento, domingo_inicio_atendimento, segunda_fim_atendimento, terca_fim_atendimento, quarta_fim_atendimento, quinta_fim_atendimento, sexta_fim_atendimento, sabado_fim_atendimento, domingo_fim_atendimento, id_empresa, id) FROM stdin;
\.
COPY public.configuracao_funcionamento (dia_segunda, dia_terca, dia_quarta, dia_quinta, dia_sexta, dia_sabado, dia_domingo, segunda_inicio_atendimento, terca_inicio_atendimento, quarta_inicio_atendimento, quinta_inicio_atendimento, sexta_inicio_atendimento, sabado_inicio_atendimento, domingo_inicio_atendimento, segunda_fim_atendimento, terca_fim_atendimento, quarta_fim_atendimento, quinta_fim_atendimento, sexta_fim_atendimento, sabado_fim_atendimento, domingo_fim_atendimento, id_empresa, id) FROM '$$PATH$$/5164.dat';

--
-- Data for Name: configuracao_rpfood; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.configuracao_rpfood (id_empresa, tempo_retirada_rpfood, tempo_entrega_rpfood, utiliza_tipo_entrega_retirada, modo_acougue, pedido_minimo, id, utiliza_controle_opcionais, utiliza_controle_ceps) FROM stdin;
\.
COPY public.configuracao_rpfood (id_empresa, tempo_retirada_rpfood, tempo_entrega_rpfood, utiliza_tipo_entrega_retirada, modo_acougue, pedido_minimo, id, utiliza_controle_opcionais, utiliza_controle_ceps) FROM '$$PATH$$/5166.dat';

--
-- Data for Name: empresas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empresas (descricao, codiuf, codicidade, uf, cidade, bairro, endereco, tipoendereco, nome, razsoc, cnpj, cep, numero, fone1, descrifone1, ddd1, email, site, complemento, id_situacao, inscricao_estadual, id_empresa) FROM stdin;
\.
COPY public.empresas (descricao, codiuf, codicidade, uf, cidade, bairro, endereco, tipoendereco, nome, razsoc, cnpj, cep, numero, fone1, descrifone1, ddd1, email, site, complemento, id_situacao, inscricao_estadual, id_empresa) FROM '$$PATH$$/5168.dat';

--
-- Data for Name: formapgto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.formapgto (id, id_empresa, descricao, id_situacao, b_venda_web, sfi_codigo) FROM stdin;
\.
COPY public.formapgto (id, id_empresa, descricao, id_situacao, b_venda_web, sfi_codigo) FROM '$$PATH$$/5170.dat';

--
-- Data for Name: grupos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grupos (codigo, descricao, img, id_situacao, id_empresa, b_exibir_web) FROM stdin;
\.
COPY public.grupos (codigo, descricao, img, id_situacao, id_empresa, b_exibir_web) FROM '$$PATH$$/5171.dat';

--
-- Data for Name: happy_hour; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.happy_hour (id, idproduto, idempresa, horainicial, horafinal, segundafeira, tercafeira, quartafeira, quintafeira, sextafeira, sabado, domingo, valor, utiliza_mesa, utiliza_delivery) FROM stdin;
\.
COPY public.happy_hour (id, idproduto, idempresa, horainicial, horafinal, segundafeira, tercafeira, quartafeira, quintafeira, sextafeira, sabado, domingo, valor, utiliza_mesa, utiliza_delivery) FROM '$$PATH$$/5172.dat';

--
-- Data for Name: mesa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mesa (mes_001, emp_001, mes_002, mes_003, id_situacao) FROM stdin;
\.
COPY public.mesa (mes_001, emp_001, mes_002, mes_003, id_situacao) FROM '$$PATH$$/5174.dat';

--
-- Data for Name: opcional; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.opcional (codigo, id_empresa, descricao, valor, id_situacao, opc_p, opc_m, opc_g, opc_extra, valor_opc_p, valor_opc_g, valor_opc_m, valor_opc_gg, valor_opc_extra, tipo, opc_gg, imagem_db) FROM stdin;
\.
COPY public.opcional (codigo, id_empresa, descricao, valor, id_situacao, opc_p, opc_m, opc_g, opc_extra, valor_opc_p, valor_opc_g, valor_opc_m, valor_opc_gg, valor_opc_extra, tipo, opc_gg, imagem_db) FROM '$$PATH$$/5175.dat';

--
-- Data for Name: produtos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produtos (codigo, descricao, codigrupo, valfinal, valcompra, observacao, img1, img2, img, id_situacao, id_empresa, b_venda_web, utiliza_combo, b_destaque_web, b_permite_frac, tamanho_p, tamanho_m, tamanho_g, tamanho_gg, tamanho_extra, tamanho_padrao, valor_tam_p, valor_tam_m, valor_tam_g, valor_tam_gg, b_venda_tamanho, valor_tam_extra, b_carrossel, utiliza_promocao, b_exporta_peso_balanca, b_peso_balanca, restringirvenda, utiliza_happy_hour, opcional_minimo, opcional_maximo) FROM stdin;
\.
COPY public.produtos (codigo, descricao, codigrupo, valfinal, valcompra, observacao, img1, img2, img, id_situacao, id_empresa, b_venda_web, utiliza_combo, b_destaque_web, b_permite_frac, tamanho_p, tamanho_m, tamanho_g, tamanho_gg, tamanho_extra, tamanho_padrao, valor_tam_p, valor_tam_m, valor_tam_g, valor_tam_gg, b_venda_tamanho, valor_tam_extra, b_carrossel, utiliza_promocao, b_exporta_peso_balanca, b_peso_balanca, restringirvenda, utiliza_happy_hour, opcional_minimo, opcional_maximo) FROM '$$PATH$$/5176.dat';

--
-- Data for Name: produtos_opcional; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produtos_opcional (id_empresa, id_material, id_opcional) FROM stdin;
\.
COPY public.produtos_opcional (id_empresa, id_material, id_opcional) FROM '$$PATH$$/5177.dat';

--
-- Data for Name: promocao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promocao (id_promocao, id_empresa, id_material, tipo_desconto, segundafeira, tercafeira, quartafeira, quintafeira, sextafeira, sabado, domingo, tipomesa, tipodelivery, tipocomanda, descontosegundapadrao, descontosegundatamanhop, descontosegundatamanhom, descontosegundatamanhog, descontosegundatamanhogg, descontosegundatamanhoextra, desconto_ter_padrao, desconto_ter_tam_p, desconto_ter_tam_m, desconto_ter_tam_g, desconto_ter_tam_gg, desconto_ter_tam_extra, desconto_qua_padrao, desconto_qua_tam_p, desconto_qua_tam_m, desconto_qua_tam_g, desconto_qua_tam_gg, desconto_qua_tam_extra, desconto_qui_padrao, desconto_qui_tam_p, desconto_qui_tam_m, desconto_qui_tam_g, desconto_qui_tam_gg, desconto_qui_tam_extra, desconto_sex_padrao, desconto_sex_tam_p, desconto_sex_tam_m, desconto_sex_tam_g, desconto_sex_tam_gg, desconto_sex_tam_extra, desconto_sab_padrao, desconto_sab_tam_p, desconto_sab_tam_m, desconto_sab_tam_g, desconto_sab_tam_gg, desconto_sab_tam_extra, desconto_dom_padrao, desconto_dom_tam_p, desconto_dom_tam_m, desconto_dom_tam_g, desconto_dom_tam_gg, desconto_dom_tam_extra) FROM stdin;
\.
COPY public.promocao (id_promocao, id_empresa, id_material, tipo_desconto, segundafeira, tercafeira, quartafeira, quintafeira, sextafeira, sabado, domingo, tipomesa, tipodelivery, tipocomanda, descontosegundapadrao, descontosegundatamanhop, descontosegundatamanhom, descontosegundatamanhog, descontosegundatamanhogg, descontosegundatamanhoextra, desconto_ter_padrao, desconto_ter_tam_p, desconto_ter_tam_m, desconto_ter_tam_g, desconto_ter_tam_gg, desconto_ter_tam_extra, desconto_qua_padrao, desconto_qua_tam_p, desconto_qua_tam_m, desconto_qua_tam_g, desconto_qua_tam_gg, desconto_qua_tam_extra, desconto_qui_padrao, desconto_qui_tam_p, desconto_qui_tam_m, desconto_qui_tam_g, desconto_qui_tam_gg, desconto_qui_tam_extra, desconto_sex_padrao, desconto_sex_tam_p, desconto_sex_tam_m, desconto_sex_tam_g, desconto_sex_tam_gg, desconto_sex_tam_extra, desconto_sab_padrao, desconto_sab_tam_p, desconto_sab_tam_m, desconto_sab_tam_g, desconto_sab_tam_gg, desconto_sab_tam_extra, desconto_dom_padrao, desconto_dom_tam_p, desconto_dom_tam_m, desconto_dom_tam_g, desconto_dom_tam_gg, desconto_dom_tam_extra) FROM '$$PATH$$/5178.dat';

--
-- Data for Name: restricoesvendas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restricoesvendas (idempresa, idproduto, segundafeira, tercafeira, quartafeira, quintafeira, sextafeira, sabado, domingo) FROM stdin;
\.
COPY public.restricoesvendas (idempresa, idproduto, segundafeira, tercafeira, quartafeira, quintafeira, sextafeira, sabado, domingo) FROM '$$PATH$$/5179.dat';

--
-- Data for Name: sincronizacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sincronizacao (id, data, id_empresa) FROM stdin;
\.
COPY public.sincronizacao (id, data, id_empresa) FROM '$$PATH$$/5180.dat';

--
-- Data for Name: transferencia_imagens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transferencia_imagens (id, tipo, id_empresa, id_registro) FROM stdin;
\.
COPY public.transferencia_imagens (id, tipo, id_empresa, id_registro) FROM '$$PATH$$/5181.dat';

--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (codigo, nome, senha, email, id_situacao) FROM stdin;
\.
COPY public.usuarios (codigo, nome, senha, email, id_situacao) FROM '$$PATH$$/5183.dat';

--
-- Data for Name: usuarios_empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios_empresa (codigo_usuario, id_empresa) FROM stdin;
\.
COPY public.usuarios_empresa (codigo_usuario, id_empresa) FROM '$$PATH$$/5184.dat';

--
-- Data for Name: usuarios_permissoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios_permissoes (codigo_usuario, b_acesso_web, b_admin_web, id_empresa) FROM stdin;
\.
COPY public.usuarios_permissoes (codigo_usuario, b_acesso_web, b_admin_web, id_empresa) FROM '$$PATH$$/5185.dat';

--
-- Data for Name: venda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venda (id_venda, id_empresa, id_situacao, id_formapgto, id_cliente, totals_products, sub_total, taxa_entrega, troco, valor_receber, sales, data_pedido, b_recebido_lecheff, tipo_entrega, observacao) FROM stdin;
\.
COPY public.venda (id_venda, id_empresa, id_situacao, id_formapgto, id_cliente, totals_products, sub_total, taxa_entrega, troco, valor_receber, sales, data_pedido, b_recebido_lecheff, tipo_entrega, observacao) FROM '$$PATH$$/5186.dat';

--
-- Data for Name: venda_endereco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venda_endereco (id_venda, id_cliente, id_bairro, cep, logradouro, numero, complemento, ponto_referencia, bairro_desc, id_endereco) FROM stdin;
\.
COPY public.venda_endereco (id_venda, id_cliente, id_bairro, cep, logradouro, numero, complemento, ponto_referencia, bairro_desc, id_endereco) FROM '$$PATH$$/5187.dat';

--
-- Data for Name: vendaitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendaitem (id_venda, id_empresa, id_product, numero_item, quantidade, valor_unit_product, totals_products, id_situacao, tamanho, b_venda_tamanho, item_fracionado, observacao, utilizou_happy_hour) FROM stdin;
\.
COPY public.vendaitem (id_venda, id_empresa, id_product, numero_item, quantidade, valor_unit_product, totals_products, id_situacao, tamanho, b_venda_tamanho, item_fracionado, observacao, utilizou_happy_hour) FROM '$$PATH$$/5189.dat';

--
-- Data for Name: vendaitemopcional; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendaitemopcional (id_venda, id_empresa, id_numero_item, id_opcional, gratis, valor, valorunitario, valortotal, quantidade, quantidade_replicar, b_recebido_lecheff) FROM stdin;
\.
COPY public.vendaitemopcional (id_venda, id_empresa, id_numero_item, id_opcional, gratis, valor, valorunitario, valortotal, quantidade, quantidade_replicar, b_recebido_lecheff) FROM '$$PATH$$/5190.dat';

--
-- Data for Name: vendamesa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendamesa (id_venda, id_empresa, id_situacao, totals_products, sub_total, sales, data_pedido, b_recebido_lecheff, observacao, numero_mesa, descricao_mesa) FROM stdin;
\.
COPY public.vendamesa (id_venda, id_empresa, id_situacao, totals_products, sub_total, sales, data_pedido, b_recebido_lecheff, observacao, numero_mesa, descricao_mesa) FROM '$$PATH$$/5191.dat';

--
-- Data for Name: vendamesaitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendamesaitem (id_venda, id_empresa, id_product, numero_item, quantidade, valor_unit_product, totals_products, id_situacao, tamanho, b_venda_tamanho, item_fracionado, observacao, b_recebido_lecheff, utilizou_happy_hour, utilizou_promocao) FROM stdin;
\.
COPY public.vendamesaitem (id_venda, id_empresa, id_product, numero_item, quantidade, valor_unit_product, totals_products, id_situacao, tamanho, b_venda_tamanho, item_fracionado, observacao, b_recebido_lecheff, utilizou_happy_hour, utilizou_promocao) FROM '$$PATH$$/5192.dat';

--
-- Data for Name: vendas_status_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendas_status_log (id_venda, id_empresa, id_situacao, data) FROM stdin;
\.
COPY public.vendas_status_log (id_venda, id_empresa, id_situacao, data) FROM '$$PATH$$/5193.dat';

--
-- Name: clientes_cli_001_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_cli_001_seq', 1, true);


--
-- Name: clientes_endereco_id_endereco_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_endereco_id_endereco_seq', 1, false);


--
-- Name: configuracao_funcionamento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.configuracao_funcionamento_id_seq', 1, false);


--
-- Name: configuracao_rpfood_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.configuracao_rpfood_id_seq', 1, false);


--
-- Name: empresas_id_empresa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empresas_id_empresa_seq', 1, true);


--
-- Name: happy_hour_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.happy_hour_id_seq', 24, true);


--
-- Name: transferencia_imagens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transferencia_imagens_id_seq', 9407, true);


--
-- Name: venda_id_venda_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venda_id_venda_seq', 1, false);


--
-- Name: configuracao_funcionamento configuracao_funcionamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuracao_funcionamento
    ADD CONSTRAINT configuracao_funcionamento_pkey PRIMARY KEY (id);


--
-- Name: configuracao_rpfood configuracao_rpfood_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuracao_rpfood
    ADD CONSTRAINT configuracao_rpfood_pkey PRIMARY KEY (id);


--
-- Name: empresas empresas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresas
    ADD CONSTRAINT empresas_pkey PRIMARY KEY (id_empresa);


--
-- Name: formapgto formapgto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapgto
    ADD CONSTRAINT formapgto_pkey PRIMARY KEY (id, id_empresa);


--
-- Name: grupos grupos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupos
    ADD CONSTRAINT grupos_pkey PRIMARY KEY (codigo, id_empresa);


--
-- Name: happy_hour happy_hour_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.happy_hour
    ADD CONSTRAINT happy_hour_pkey PRIMARY KEY (id);


--
-- Name: opcional opcional_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opcional
    ADD CONSTRAINT opcional_pkey PRIMARY KEY (codigo, id_empresa);


--
-- Name: bairro pk_bairro; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bairro
    ADD CONSTRAINT pk_bairro PRIMARY KEY (bai_001, emp_001);


--
-- Name: bairro_ceps pk_bairro_ceps; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bairro_ceps
    ADD CONSTRAINT pk_bairro_ceps PRIMARY KEY (bai_001, emp_001, cep);


--
-- Name: clientes_endereco pk_clientes_endereco; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes_endereco
    ADD CONSTRAINT pk_clientes_endereco PRIMARY KEY (id_endereco, id_empresa);


--
-- Name: promocao pk_promocao; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocao
    ADD CONSTRAINT pk_promocao PRIMARY KEY (id_promocao, id_empresa);


--
-- Name: usuarios pk_usuarios; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT pk_usuarios PRIMARY KEY (codigo);


--
-- Name: usuarios_empresa pk_usuarios_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_empresa
    ADD CONSTRAINT pk_usuarios_empresa PRIMARY KEY (codigo_usuario, id_empresa);


--
-- Name: venda pk_venda; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT pk_venda PRIMARY KEY (id_venda, id_empresa);


--
-- Name: vendaitem pk_vendaitem; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendaitem
    ADD CONSTRAINT pk_vendaitem PRIMARY KEY (id_venda, id_empresa, numero_item);


--
-- Name: vendamesaitem pk_vendamesaitem; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendamesaitem
    ADD CONSTRAINT pk_vendamesaitem PRIMARY KEY (id_venda, id_empresa, numero_item);


--
-- Name: produtos produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (codigo, id_empresa);


--
-- Name: venda_endereco venda_endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_endereco
    ADD CONSTRAINT venda_endereco_pkey PRIMARY KEY (id_venda, id_cliente);


--
-- Name: bairro_ceps fk_bairro_ceps; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bairro_ceps
    ADD CONSTRAINT fk_bairro_ceps FOREIGN KEY (bai_001, emp_001) REFERENCES public.bairro(bai_001, emp_001) ON DELETE CASCADE;


--
-- Name: formapgto fk_formapgto_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formapgto
    ADD CONSTRAINT fk_formapgto_id FOREIGN KEY (id_empresa) REFERENCES public.empresas(id_empresa) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promocao fk_promocao_idmaterial; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocao
    ADD CONSTRAINT fk_promocao_idmaterial FOREIGN KEY (id_material, id_empresa) REFERENCES public.produtos(codigo, id_empresa) ON DELETE CASCADE;


--
-- Name: vendaitem fk_venda_item_empresa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendaitem
    ADD CONSTRAINT fk_venda_item_empresa FOREIGN KEY (id_empresa) REFERENCES public.empresas(id_empresa) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               