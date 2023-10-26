--1. Lấy thông tin về tên, vị trí, cân nặng và chiều cao của cầu thủ đến từ England.
SELECT name, position, weight, height
FROM player
WHERE nation = 'England';
--2. Lấy thông tin về tên, quốc tịch và kinh nghiệm của huấn luyện viên Eric Ten Hag
SELECT name, nation, ex
FROM coach
WHERE name = 'Eric Ten Hag';
--3. Tìm tên, vị trí, quốc tịch, matchid trận tham gia của tất cả các cầu thủ đã thi đấu trong các trận đấu diễn ra vào tháng 8/2020.
SELECT p.name, p.position, p.nation, m.Matchid
FROM player p
JOIN thidau t ON p.playerid = t.playerid
JOIN match m ON t.teamid = m.Teamid1 OR t.teamid = m.Teamid2
WHERE EXTRACT(MONTH FROM m.ngay) = 8 AND EXTRACT(YEAR FROM m.ngay) = 2020;
--4. Lấy thông tin về tên, quốc tịch và năm thành lập của đội bóng Barcelona.
SELECT name, country, DOF
FROM team
WHERE name = 'Barcelona';
--5. Lấy thông tin về tên, quốc gia và ngày thành lập của tất cả các đội bóng trong giải đấu J.League.
SELECT t.name, t.country, t.DOF
FROM team t
JOIN thamgia tg ON t.teamid = tg.teamid
JOIN league l ON tg.leagueid = l.leagueid
WHERE l.name = 'J.League';
--6. Tìm tên và quốc gia của tất cả các đội bóng đã tham gia trận đấu với kết quả là thắng.
SELECT t.name, t.country
FROM team t
JOIN match m ON t.teamid = m.teamid1 OR t.teamid = m.teamid2
WHERE m.win = t.teamid;
--7. Lấy thông tin về tất cả các huấn luyện viên và đội bóng mà họ đang làm việc.
SELECT c.name AS coach_name, t.name AS team_name
FROM coach c
JOIN huanluyen h ON c.Coachid = h.coachid
JOIN team t ON h.teamid = t.teamid;
--8. Lấy thông tin về tất cả các đội bóng và giải đấu mà họ tham gia.
SELECT t.name AS team_name, l.name AS league_name
FROM team t
JOIN thamgia tg ON t.teamid = tg.teamid
JOIN league l ON tg.leagueid = l.leagueid;
--9. Lấy thông tin về tất cả các cầu thủ và đội bóng mà họ đang chơi.
SELECT p.name AS player_name, t.name AS team_name
FROM player p
JOIN thidau td ON p.playerid = td.playerid
JOIN team t ON td.teamid = t.teamid;
--10. Lấy thông tin về tất cả các đội bóng và sân vận động mà họ sử dụng.
SELECT t.name AS team_name, s.name AS stadium_name
FROM team t
JOIN stadium s ON t.stadiumid = s.stadiumid;
--11. Lấy thông tin về tất cả các trận đấu và sân vận động mà chúng diễn ra.
SELECT m.Matchid, s.name AS stadium_name
FROM match m
JOIN stadium s ON m.stadiumid = s.stadiumid;
--12. Lấy thông tin về tất cả các cầu thủ từ Mỹ.
SELECT *
FROM player
WHERE nation = 'United States';
--13. Lấy thông tin về tất cả các đội bóng từ một thành phố Milan.
SELECT *
FROM team
WHERE city = 'Milan';
--14. Lấy thông tin về tất cả các đội bóng từ Tây Ban Nha.
SELECT *
FROM team
WHERE country = 'Spain';
--15. Lấy thông tin về tất cả các trận đấu từ ngày 26/5/2023.
SELECT *
FROM match
WHERE ngay = '2023-05-26';
--16. Lấy thông tin về tất cả các trận đấu mà Manchester United đã tham gia.
SELECT *
FROM match
JOIN team t ON t.teamid = m.teamid1 OR t.teamid = m.teamid2
WHERE t.name = 'Manchester United';
--17. Lấy thông tin về tất cả các trận đấu trong giải Premier League.
SELECT *
FROM match m
JOIN thamgia tg ON m.Leagueid = tg.Leagueid
JOIN league l ON m.Leagueid = l.leagueid
WHERE l.leagueid = 'Premier League';
--18. Lấy thông tin về tất cả các trận đấu mà Martial tham gia.
SELECT m.Matchid, m.ngay, m.Results
FROM match m
JOIN thidau td ON m.Teamid1 = td.teamid OR m.Teamid2 = td.teamid
JOIN player p ON td.playerid = p.playerid
WHERE p.name = 'Martial';
--19. Lấy thông tin về tất cả các giải đấu mà Atletico Madrid tham gia.
SELECT l.name AS league_name, l.quantity
FROM league l
JOIN thamgia tg ON l.leagueid = tg.leagueid
JOIN team t ON tg.teamid = t.teamid
WHERE t.name = 'Atletico Madrid';
--20. Lấy thông tin về tất cả các trận đấu mà sân vận động Old Trafford đã tổ chức.
SELECT m.Matchid, m.ngay, m.Teamid1, m.Teamid2
FROM match m
JOIN stadium s ON m.stadiumid = s.stadiumid
WHERE s.name = 'Old Trafford';
--21. Lấy thông tin về tất cả các huấn luyện viên của Netherlands.
SELECT *
FROM coach
WHERE nation = 'Netherlands';
--22. Lấy thông tin về tất cả các đội bóng được huấn luyện bởi HLV Jose Mourinho.
SELECT t.name AS team_name, c.name AS coach_name
FROM team t
JOIN huanluyen h ON t.teamid = h.teamid
JOIN coach c ON h.coachid = c.coachid
WHERE c.name = 'Jose Mourinho';
--23. Lấy thông tin về tất cả các đội bóng tham gia UEFA Champions League năm 20223.
SELECT t.name AS team_name
FROM team t
JOIN thamgia tg ON t.teamid = tg.teamid
JOIN league l ON tg.leagueid = l.leagueid
WHERE l.name = 'UEFA Champions League' AND tg.Year = '2023';
--24. Lấy thông tin về tất cả các cầu thủ là tiền đạo chạy cánh trái.
SELECT *
FROM player
WHERE position = 'LW';
--25. Lấy thông tin về tất cả các trận đấu kết thúc với một kết quả 4-1.
SELECT *
FROM match
WHERE Results = '4-1';
--26. Lấy thông tin về tất cả các đội bóng vô địch La Liga trong năm 2021.
SELECT t.name AS team_name
FROM team t
JOIN vodich vd ON t.teamid = vd.Teamid
WHERE vd.Leagueid = 'La liga' AND vd.Year = '2021';
--27. Lấy thông tin về tất cả các đội bóng mà cầu thủ Trent Alexander-Arnold chơi trong năm 2023.
SELECT t.name AS team_name
FROM team t
JOIN thidau td ON t.teamid = td.teamid
JOIN player p ON td.playerid = p.playerid
WHERE p.name = 'Trent Alexander-Arnold' AND td.year = '2023';
--28. Lấy thông tin về tất cả các trận đấu mà hai đội bóng MU và Chelsea đối đầu.
SELECT DISTINCT *
FROM match m
LEFT JOIN team t ON t.teamid = m.teamid1 OR t.teamid = m.teamid2
WHERE t.name = 'Manchester United' OR t.name = 'Chelsea';

--29. Lấy thông tin về tất cả các trận đấu diễn ra tại sân vận động Anfield trong năm 2020.
SELECT *
FROM match
JOIN stadium ON match.stadiumid = stadium.stadiumid
WHERE stadium.name = 'Anfield' AND match.ngay BETWEEN '2020-01-01' AND '2020-12-31';
--30. Lấy thông tin về tất cả các trận đấu diễn ra trong giải đấu UEFA Champions League, tại sân vận động Old Trafford, trong năm 2023.
SELECT m.*
FROM match m
JOIN league l ON m.leagueid = l.leagueid
JOIN stadium s ON m.stadiumid = s.stadiumid
WHERE l.name = 'UEFA Champions League' AND s.name = 'Old Trafford' AND m.ngay BETWEEN '2023-01-01' AND '2023-12-31';