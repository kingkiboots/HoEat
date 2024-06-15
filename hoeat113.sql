create table member(
mid varchar2(100),
mpwd varchar2(50) not null,
mname varchar2(20) not null,
mbirth number not null,
mgender varchar2(10) not null,
memail varchar2(255) not null,
mdate date,
constraint member_mid_pk primary key(mid)
);

create table board(
bnum number,
mid varchar2(100) not null,
btitle varchar2(255) not null,
bcont clob not null,
bimg varchar2(200) not null,
bingredient clob not null,
bhit number not null,
bcate varchar2(100) not null,
bdate date not null,
constraint board_bnum_pk primary key(bnum),
constraint board_mid_fk foreign key(mid) references member(mid) on delete cascade
);

create table review(
rnum number,
mid varchar2(100) not null,
bnum number not null,
rscore number not null,
rcont clob not null,
rdate date not null,
constraint review_rnum_pk primary key(rnum),
constraint review_mid_fk foreign key(mid) references member(mid) on delete cascade,
constraint review_bnum_fk foreign key(bnum) references board(bnum) on delete cascade
);

create table jjim(
jnum number,
mid varchar2(100) not null,
bnum number not null,
constraint jjim_jnum_pk primary key(jnum),
constraint jjim_mid_fk foreign key(mid) references member(mid) on delete cascade,
constraint jjim_bnum_fk foreign key(bnum) references board(bnum) on delete cascade
);

create table staylog(
snum number primary key,
mem varchar2(20),
staytime number,
sdate date
);

create table movelog(
mnum number,
mem varchar2(20),
movetime number,
mdate date
);

create sequence member_seq
increment by 1 start with 1;
create sequence logging_seq
increment by 1 start with 1;
create sequence board_seq
increment by 1 start with 1;
create sequence review_seq
increment by 1 start with 1;
create sequence jjim_seq
increment by 1 start with 1;
create sequence staylog_seq
increment by 1 start with 1;
create sequence movelog_seq
increment by 1 start with 1;


-- 찜테이블 프로시저
create or replace procedure pro_jjim1
    (m_id jjim.mid%type,
    b_num jjim.bnum%type,
    countl out number,
    ck out number)
is
    cresult varchar2(10);
    inti number;
    e_invalid exception;
    PRAGMA exception_init(e_invalid, -02291);
begin
    cresult := jjim1(m_id, b_num);
    if cresult = 'ins' then
        insert into jjim values(jjim_seq.nextVal, m_id, b_num);
        ck := 1;                                   --ck : 찜하고 난 후 상태를 반환 => 1: 찜 설정, 0: 찜 해제 
    else
        delete from jjim where mid = m_id and bnum = b_num;
        ck := 0;
    end if;
    commit;
    select count(*) into countl from jjim where bnum = b_num; -- countl : 게시물의 총 찜수를 반환

    exception
        when e_invalid then inti:=0;   
end;

-- 찜테이블 함수
create or replace function jjim1
    (m_id jjim.mid%type,
    b_num jjim.bnum%type)
    return varchar2
is
    cresult varchar2(10); -- 
    countl number;
begin
     select count(*) into countl from jjim where mid = m_id and bnum = b_num;
    --로그인한 유저가 해당 식당에 찜데이터가 1개일때(이미 찜을 한것) : del를 반환
    --아닐경우 ins를 반환
    if countl = 0 then 
        cresult := 'ins';
    else 
        cresult := 'del';
    end if;
    return cresult;
end;

-- 로그 더미데이터
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (176,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (183,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (184,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (186,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (187,'test',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (188,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (189,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (190,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (191,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (321,'test',17,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (322,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (323,'test',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (192,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (193,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (164,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (169,'Guest1987654',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (144,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (155,'test',4,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (171,'Guest1987654',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (182,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (198,'test2',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (247,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (248,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (258,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (286,'test',6,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (296,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (304,'test2',4,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (350,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (366,'Guest1987654',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (368,'Guest1987654',9,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (369,'Guest1987654',2,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (125,'test',12,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (126,'test',14,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (127,'test',15,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (128,'test',13,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (129,'test',7,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (185,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (341,'test',2,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (342,'test2',9,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (343,'test2',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (344,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (345,'test2',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (346,'test2',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (347,'test2',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (348,'test2',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (349,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (351,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (352,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (353,'test2',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (354,'test',4,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (355,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (356,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (357,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (358,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (359,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (360,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (361,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (362,'Guest1987654',2,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (363,'Guest1987654',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (364,'Guest1987654',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (365,'Guest1987654',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (381,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (382,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (401,'test',11,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (412,'test',9,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (425,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (433,'test',7,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (443,'test',9,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (449,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (450,'test',9,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (484,'test',3,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (488,'test',1,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (76,'test',8,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (77,'test',2,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (78,'test',4,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (79,'test',3,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (80,'test',3,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (81,'test',7,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (82,'test',8,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (83,'test',2,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (84,'test',4,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (85,'test',3,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (86,'test',3,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (87,'test',7,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (88,'test',8,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (89,'test',2,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (90,'test',4,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (91,'test',3,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (92,'test',3,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (93,'test',7,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (94,'test',8,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (95,'test',2,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (96,'test',4,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (97,'test',10,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (98,'test',3,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (99,'test',7,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (100,'test',8,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (101,'test',2,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (102,'test',4,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (103,'test',10,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (104,'test',3,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (105,'test',7,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (106,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (107,'test',12,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (108,'test',14,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (109,'test',15,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (110,'test',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (111,'test',7,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (112,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (113,'test',12,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (114,'test',14,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (115,'test',15,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (116,'test',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (117,'test',7,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (118,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (119,'test',12,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (120,'test',14,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (121,'test',15,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (122,'test',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (123,'test',7,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (124,'test',15,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (132,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (133,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (134,'test',6,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (130,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (131,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (135,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (136,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (137,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (138,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (139,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (140,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (141,'test',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (142,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (143,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (145,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (146,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (147,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (148,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (149,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (150,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (151,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (152,'test',8,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (153,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (154,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (156,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (157,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (158,'test',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (159,'test',6,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (160,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (161,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (162,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (163,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (165,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (166,'test',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (167,'Guest1987654',9,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (168,'Guest1987654',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (170,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (172,'Guest1987654',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (173,'Guest1987654',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (174,'Guest1987654',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (175,'Guest',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (177,'test',6,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (178,'test',4,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (179,'test',4,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (180,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (181,'test',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (194,'test2',8,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (195,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (196,'test2',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (197,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (199,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (200,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (201,'test2',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (202,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (203,'test2',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (204,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (205,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (206,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (207,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (208,'test2',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (209,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (210,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (211,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (212,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (213,'test',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (214,'test',4,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (215,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (216,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (217,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (218,'test',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (219,'test',4,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (220,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (221,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (222,'test',4,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (223,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (224,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (225,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (226,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (227,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (228,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (229,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (230,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (231,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (232,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (233,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (234,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (235,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (236,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (237,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (238,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (239,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (240,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (241,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (242,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (243,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (244,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (245,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (246,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (249,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (250,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (251,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (252,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (253,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (254,'test',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (255,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (256,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (257,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (259,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (260,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (261,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (262,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (263,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (264,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (265,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (266,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (267,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (268,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (269,'test2',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (270,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (271,'test2',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (272,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (273,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (274,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (275,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (276,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (277,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (278,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (279,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (280,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (281,'test2',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (282,'test2',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (283,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (284,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (285,'test',4,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (287,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (288,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (289,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (290,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (291,'test',4,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (292,'test',9,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (293,'test2',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (294,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (295,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (297,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (298,'test2',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (299,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (300,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (301,'test2',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (302,'test2',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (303,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (305,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (306,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (307,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (308,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (309,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (310,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (311,'test2',8,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (312,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (313,'test2',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (314,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (315,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (316,'test2',4,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (317,'test2',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (318,'test2',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (319,'test2',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (320,'test2',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (324,'test',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (367,'Guest1987654',8,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (370,'Guest1987654',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (371,'Guest1987654',2,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (372,'Guest1987654',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (373,'Guest1987654',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (374,'Guest1987654',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (375,'Guest1987654',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (376,'Guest1987654',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (377,'Guest1987654',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (378,'Guest1987654',2,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (379,'Guest1987654',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (380,'test2',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (383,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (384,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (385,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (386,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (387,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (388,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (389,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (390,'test2',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (391,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (392,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (393,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (394,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (395,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (396,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (397,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (398,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (399,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (400,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (402,'test',23,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (403,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (404,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (405,'test',15,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (406,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (407,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (408,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (409,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (410,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (411,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (413,'test',15,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (414,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (415,'test',7,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (416,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (417,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (418,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (419,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (420,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (421,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (422,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (423,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (424,'test',7,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (426,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (427,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (428,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (429,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (430,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (431,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (432,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (434,'test',13,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (435,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (436,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (437,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (438,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (439,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (440,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (441,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (442,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (444,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (445,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (446,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (447,'test',7,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (448,'test',7,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (451,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (452,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (453,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (454,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (455,'test',11,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (456,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (457,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (458,'test',9,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (459,'test',17,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (460,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (461,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (462,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (463,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (464,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (465,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (466,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (467,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (468,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (469,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (470,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (471,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (472,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (473,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (474,'test',7,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (475,'Guest123456789',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (476,'Guest123456789',7,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (477,'test',15,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (478,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (479,'test',1,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (480,'test',3,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (481,'test',5,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (482,'test',1,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (483,'test',3,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (485,'test',3,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (486,'test',1,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (487,'test',1,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (489,'test',1,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.MOVELOG (MNUM,MEM,MOVETIME,MDATE) values (490,'test',5,to_date('22/08/26','RR/MM/DD'));

-- 로그 더미데이터2
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (111,'test',880,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (112,'test',8,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (114,'test',85,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (115,'test',140,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (116,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (117,'test',8,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (118,'test',16,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (119,'test',19,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (249,'test',1988,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (250,'test',16,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (405,'test',85,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (406,'test',129,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (407,'test',56,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (409,'test',41,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (410,'test',80,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (29,'Guest1987654',221,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (120,'test',117,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (121,'test',11,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (251,'test',244,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (23,'test',4,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (24,'test',2,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (72,'test',29,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (83,'test',66,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (92,'test',97,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (97,'Guest1987654',800,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (99,'Guest1987654',146,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (110,'test',35,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (126,'test2',32,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (175,'test',12,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (176,'test',21,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (186,'test',47,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (214,'test',651,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (224,'test2',80,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (232,'test2',1335,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (270,'test',56,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (286,'Guest1987654',24,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (289,'Guest1987654',14,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (25,'Guest1987654',9,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (30,'Guest1',15,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (31,'Guest1',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (32,'Guest1',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (33,'Guest1',34,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (34,'Guest1',34,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (35,'Guest1',324,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (36,'Guest1',31,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (37,'Guest1',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (38,'Guest1',34,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (39,'Guest1',324,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (40,'Guest1',31,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (41,'Guest1',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (42,'Guest1',314,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (43,'Guest1',4,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (44,'Guest1',21,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (45,'Guest1',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (46,'Guest1',314,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (47,'Guest1',24,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (48,'Guest1',41,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (49,'Guest1',55,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (50,'Guest1',314,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (51,'Guest1',24,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (52,'Guest1',41,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (53,'Guest1',55,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (54,'Guest1',411,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (55,'Guest1',51,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (56,'Guest1',4,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (57,'Guest1',11,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (113,'test',15,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (261,'test',19,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (262,'test2',311,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (263,'test2',27,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (264,'test',328,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (265,'test2',6,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (266,'test2',87,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (267,'test2',46,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (268,'test2',8,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (269,'test',4,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (271,'test',83,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (272,'test',14,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (273,'test2',39,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (274,'test',42,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (275,'test',76,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (276,'test',11,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (277,'test',7,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (278,'test',122,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (279,'test',34,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (280,'test',33,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (281,'test',179,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (282,'Guest1987654',855,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (283,'Guest1987654',11,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (284,'Guest1987654',2,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (285,'Guest1987654',2,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (301,'test',386,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (302,'test',6,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (321,'test',131,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (332,'test',144,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (345,'test',60,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (353,'test',44,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (363,'test',99,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (369,'test',480,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (370,'test',609,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (404,'test',820,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (408,'test',16,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (22,'Guest1987654',3,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (26,'Guest1987654',18,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (27,'Guest1987654',66,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (28,'Guest1987654',18,to_date('22/08/23','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (58,'test',22,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (59,'test',83,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (60,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (61,'test',18,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (62,'test',66,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (63,'test',7,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (64,'test',36,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (65,'test',57,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (66,'test',8,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (67,'test',21,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (68,'test',12,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (69,'test',34,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (70,'test',14,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (71,'test',44,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (73,'test',64,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (74,'test',42,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (75,'test',1216,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (76,'test',9,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (77,'test',29,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (78,'test',19,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (79,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (80,'test',161,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (81,'test',469,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (82,'test',8,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (84,'test',93,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (85,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (86,'test',81,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (87,'test',1466,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (88,'test',9,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (89,'test',48,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (90,'test',23,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (91,'test',41,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (93,'test',47,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (94,'test',226,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (95,'Guest1987654',3456,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (96,'Guest1987654',561,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (98,'test',8,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (100,'Guest1987654',18,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (101,'Guest1987654',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (102,'Guest1987654',28,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (103,'Guest',7,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (104,'test',9,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (105,'test',61,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (106,'test',9,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (107,'test',2135,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (108,'test',9,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (109,'test',12,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (122,'test2',427,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (123,'test2',12,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (124,'test2',10,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (125,'test2',14,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (127,'test2',24,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (128,'test2',8,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (129,'test2',502,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (130,'test2',106,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (131,'test2',18,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (132,'test2',18,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (133,'test',37,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (134,'test2',7,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (135,'test',17,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (136,'test2',267,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (137,'test2',145,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (138,'test2',9,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (139,'test2',14,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (140,'test',14,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (141,'test',15,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (142,'test',133,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (143,'test',103,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (144,'test',9,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (145,'test2',39,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (146,'test',109,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (147,'test',39,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (148,'test',27,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (149,'test',4,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (150,'test',260,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (151,'test',474,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (152,'test',156,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (153,'test',127,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (154,'test',122,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (155,'test',32,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (156,'test',6,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (157,'test',6,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (158,'test',14,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (159,'test',77,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (160,'test',17,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (161,'test',6,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (162,'test',134,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (163,'test',13,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (164,'test',9,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (165,'test',23,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (166,'test',27,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (167,'test',15,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (168,'test',39,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (169,'test',33,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (170,'test',8,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (171,'test',19,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (172,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (173,'test',10,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (174,'test',2,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (177,'test',6,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (178,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (179,'test',1,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (180,'test',162,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (181,'test',58,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (182,'test',145,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (183,'test',429,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (184,'test',41,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (185,'test',6,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (187,'test',31,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (188,'test',16,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (189,'test',98,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (190,'test',9,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (191,'test',7,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (192,'test',9,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (193,'test',24,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (194,'test',11,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (195,'test',40,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (196,'test',131,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (197,'test2',300,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (198,'test2',58,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (199,'test2',60,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (200,'test2',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (201,'test2',14,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (202,'test2',11,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (203,'test2',8,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (204,'test2',95,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (205,'test2',576,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (206,'test2',68,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (207,'test2',11,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (208,'test2',17,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (209,'test2',115,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (210,'test2',2994,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (211,'test',9,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (212,'test',5,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (213,'test',15,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (215,'test',79,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (216,'test',18,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (217,'test',14,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (218,'test',19,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (219,'test',57,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (220,'test',78,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (221,'test2',215,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (222,'test2',34,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (223,'test2',15,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (225,'test2',41,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (226,'test2',38,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (227,'test2',11,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (228,'test2',10,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (229,'test2',24,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (230,'test2',267,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (231,'test2',53,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (233,'test2',88,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (234,'test2',47,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (235,'test2',19,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (236,'test2',54,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (237,'test2',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (238,'test2',12,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (239,'test2',478,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (240,'test2',12,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (241,'test2',62,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (242,'test2',3,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (243,'test2',7,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (244,'test2',1201,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (245,'test2',302,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (246,'test2',194,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (247,'test2',29,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (248,'test2',528,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (252,'test',98,to_date('22/08/24','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (287,'Guest1987654',4077,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (288,'Guest1987654',4162,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (290,'Guest1987654',24,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (291,'Guest1987654',66,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (292,'Guest1987654',21,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (293,'Guest1987654',15,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (294,'Guest1987654',27,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (295,'Guest1987654',2,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (296,'Guest1987654',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (297,'Guest1987654',6,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (298,'Guest1987654',2306,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (299,'Guest1987654',2969,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (300,'test2',10558,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (303,'test',777,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (304,'test',25,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (305,'test',44,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (306,'test',84,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (307,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (308,'test',4,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (309,'test',23,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (310,'test2',126,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (311,'test',40,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (312,'test',1079,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (313,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (314,'test',25,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (315,'test',597,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (316,'test',7,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (317,'test',494,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (318,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (319,'test',1238,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (320,'test',8,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (322,'test',204,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (323,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (324,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (325,'test',455,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (326,'test',6,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (327,'test',104,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (328,'test',4,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (329,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (330,'test',89,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (331,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (333,'test',185,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (334,'test',6,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (335,'test',106,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (336,'test',48,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (337,'test',4,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (338,'test',10,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (339,'test',21,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (340,'test',4,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (341,'test',48,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (342,'test',70,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (343,'test',6,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (344,'test',9,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (346,'test',110,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (347,'test',53,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (348,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (349,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (350,'test',166,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (351,'test',53,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (352,'test',130,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (354,'test',207,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (355,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (356,'test',35,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (357,'test',3,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (358,'test',9,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (359,'test',13,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (360,'test',84,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (361,'test',4,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (362,'test',149,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (364,'test',120,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (365,'test',35,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (366,'test',8,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (367,'test',485,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (368,'test',38,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (371,'test',95,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (372,'test',101,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (373,'test',38,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (374,'test',60,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (375,'test',258,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (376,'test',41,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (377,'test',48,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (378,'test',1146,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (379,'test',233,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (380,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (381,'test',95,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (382,'test',13,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (383,'test',23,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (384,'test',35,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (385,'test',37,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (386,'test',193,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (387,'test',42,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (388,'test',2,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (389,'test',5,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (390,'test',159,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (391,'test',6,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (392,'test',1265,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (393,'test',142,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (394,'test',573,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (395,'Guest123456789',62,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (396,'Guest123456789',63,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (397,'test',241,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (398,'test',175,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (399,'test',7,to_date('22/08/25','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (400,'test',128,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (401,'test',28,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (402,'test',63,to_date('22/08/26','RR/MM/DD'));
Insert into PYTHON113.STAYLOG (SNUM,MEM,STAYTIME,SDATE) values (403,'test',143,to_date('22/08/26','RR/MM/DD'));
