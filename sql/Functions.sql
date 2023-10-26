--1. Lấy thông tin về tên, vị trí, cân nặng và chiều cao của cầu thủ đến từ một quốc gia nào đó và có giá trị chuyển nhượng cao nhất.
CREATE OR REPLACE FUNCTION test_function1(nation_pro text)
  RETURNS TABLE (name varchar,positon varchar,value varchar)
AS $$
BEGIN
    RETURN QUERY
    SELECT a.name,a.position,b.value
    FROM player a
    INNER JOIN thidau b ON a.playerid = b.playerid
    WHERE a.nation = nation_pro
    ORDER BY CAST(REPLACE(REPLACE(b.value, '.', ''), '$', '') AS INT) DESC
    LIMIT 1;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM test_function1('England');

--2. Lấy số danh hiệu của đội bóng theo tên
CREATE OR REPLACE FUNCTION test_function2(name_pro text)
  RETURNS TABLE (name varchar,total bigint)
AS $$
BEGIN
    RETURN QUERY
    select team.name,count(vodich.id) as total
	from team
	left join vodich
	on team.teamid = vodich.teamid
	where team.name = name_pro
	group by team.name;
END;
$$
LANGUAGE plpgsql;

select * from test_function2('Real Madrid');

--3. Tìm tên, vị trí, quốc tịch, matchid trận tham gia của tất cả các cầu thủ đã thi đấu trong các trận đấu diễn ra vào tháng/năm
CREATE OR REPLACE FUNCTION test_function3(thang_pro int,nam_pro int)
  RETURNS TABLE (name varchar,vi_tri varchar,nation varchar, matchid varchar)
AS $$
BEGIN
    RETURN QUERY
    SELECT p.name, p.position, p.nation, m.Matchid
	FROM player p
	JOIN thidau t ON p.playerid = t.playerid
	JOIN match m ON t.teamid = m.Teamid1 OR t.teamid = m.Teamid2
	WHERE EXTRACT(MONTH FROM m.ngay) = thang_pro AND EXTRACT(YEAR FROM m.ngay) = nam_pro;
END;
$$
LANGUAGE plpgsql;

select * from test_function3(8,2020);

--4. Lấy danh sách các đội bóng vừa tham gia cùng lúc 2 giải đấu 
CREATE OR REPLACE FUNCTION test_function34(league_pro1 text,league_pro2 text, year_pro text)
  RETURNS TABLE (name varchar)
AS $$
BEGIN
    RETURN QUERY
    (SELECT t.name AS team_name
	FROM team t
	JOIN thamgia tg ON t.teamid = tg.teamid
	JOIN league l ON tg.leagueid = l.leagueid
	WHERE l.name = league_pro1 AND tg.Year = year_pro)
	intersect
	(SELECT t.name AS team_name
	FROM team t
	INNER JOIN thamgia tg ON t.teamid = tg.teamid
	INNER JOIN league l ON tg.leagueid = l.leagueid AND l.name = league_pro2
	WHERE tg.Year = year_pro);
END;
$$
LANGUAGE plpgsql;

select * from test_function34('UEFA Champions League','Giai vo đich bong đa Anh','2023');

--5. Lấy thông tin về các trận đấu của một đội nhất định, bao gồm tên đối thủ, ngày diễn ra và kết quả
SELECT M.Ngay, CASE WHEN M.TeamId1 = 'Team001' THEN T2.Name ELSE T1.Name END AS Opponent, M.Results
FROM Match M
JOIN Team T1 ON M.TeamId1 = T1.TeamId
JOIN Team T2 ON M.TeamId2 = T2.TeamId
WHERE M.TeamId1 = 'Team001' OR M.TeamId2 = 'Team001';

CREATE OR REPLACE FUNCTION function5(name_pro text)
  RETURNS TABLE (ngay_pro date,Opponent varchar, result varchar)
AS $$
BEGIN
    RETURN QUERY
    SELECT M.Ngay, CASE WHEN M.TeamId1 = name_pro THEN T2.Name ELSE T1.Name END AS Opponent, M.Results
	FROM Match M
	JOIN Team T1 ON M.TeamId1 = T1.TeamId
	JOIN Team T2 ON M.TeamId2 = T2.TeamId
	WHERE M.TeamId1 = name_pro OR M.TeamId2 = name_pro;
END;
$$
LANGUAGE plpgsql;

select * from function5('Team001');

--6. Hiển thị số trận đấu của 1 cầu thủ nào đó (Do mình nhập vào)
CREATE OR REPLACE FUNCTION function6(name_pro text)
  RETURNS TABLE (playerid varchar,name varchar,value varchar,team varchar, totalmatch bigint)
AS $$
BEGIN
    RETURN QUERY
    SELECT Player.PlayerId, Player.Name, thidau.value, team.name, COUNT(Match.MatchId) AS MatchCount
	FROM Player
	JOIN thidau ON Player.PlayerId = thidau.PlayerId
	JOIN Match ON (thidau.TeamId = Match.TeamId1 OR thidau.TeamId = Match.TeamId2)
	JOIN team ON thidau.teamid = team.teamid
	WHERE player.name = name_pro
	GROUP BY Player.PlayerId, Player.Name,thidau.value,team.name;
END;
$$
LANGUAGE plpgsql;

select * from function6('Casemiro');

--7. Hiển thị các đội bóng mà 1 cầu thủ đã thi đấu
CREATE OR REPLACE FUNCTION function7(name_pro text)
  RETURNS TABLE (name varchar,team_name varchar,year varchar)
AS $$
BEGIN
    RETURN QUERY
    SELECT player.name,team.name,thidau.year varchar 
	FROM player 
	inner join thidau 
	on player.playerid = thidau.playerid
	inner join team
	on thidau.teamid = team.teamid
	where player.name = name_pro;
END;
$$
LANGUAGE plpgsql;

select * from function7('Neymar Jr');

--8. Hiển thị các đội bóng mà 1 huấn luyện viên huấn luyện
CREATE OR REPLACE FUNCTION function8(name_pro text)
  RETURNS TABLE (name varchar,team_name varchar,year varchar)
AS $$
BEGIN
    RETURN QUERY
    SELECT coach.name,team.name,huanluyen.year varchar 
	FROM coach 
	inner join huanluyen 
	on coach.coachid = huanluyen.coachid
	inner join team
	on huanluyen.teamid = team.teamid
	where coach.name = name_pro;
END;
$$
LANGUAGE plpgsql;

select * from function8('Pep Guardiola');

--9. Hiển thị top 3 cầu thủ có giá trị chuyển nhượng cao nhất của 1 giải đấu
CREATE OR REPLACE FUNCTION function9(league_pro text)
  RETURNS TABLE (name varchar,positon varchar,value varchar)
AS $$
BEGIN
    RETURN QUERY
    SELECT a.name,a.position,b.value
    FROM player a
    INNER JOIN thidau b ON a.playerid = b.playerid
   	inner join team on b.teamid = team.teamid
	inner join thamgia on team.teamid = thamgia.teamid
	inner join league on thamgia.leagueid = league.leagueid
	where league.leagueid = league_pro
    ORDER BY CAST(REPLACE(REPLACE(b.value, '.', ''), '$', '') AS INT) DESC
    LIMIT 3;
END;
$$
LANGUAGE plpgsql;

select * from function9('Premier League');