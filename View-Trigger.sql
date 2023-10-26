--1. Tạo view để xem giá trị cầu thủ theo thứ tự giảm dần và trigger để tự động cập nhật view trên sau khi dữ liệu cho thêm cầu thủ mới.
CREATE OR REPLACE VIEW player_thidau_view AS
SELECT p.playerid, p.name, p.nation, td.value
FROM player p
JOIN thidau td ON p.playerid = td.playerid
ORDER BY td.value DESC;

CREATE OR REPLACE FUNCTION update_player_thidau_view()
  RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW player_thidau_view;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_player_thidau_view_trigger
AFTER INSERT ON Player
FOR EACH STATEMENT
EXECUTE FUNCTION update_player_thidau_view();

--2. Tạo trigger tự động cập nhật năm kinh nghiệm cho HLV mỗi khi sang năm mới
CREATE OR REPLACE FUNCTION increase_coach_experience()
  RETURNS TRIGGER AS $$
BEGIN
  IF EXTRACT(YEAR FROM CURRENT_DATE) > EXTRACT(YEAR FROM OLD.insert_date::date) THEN
    UPDATE coach
    SET ex = ex + 1
    WHERE coachid = OLD.coachid;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER increase_coach_experience_trigger
BEFORE UPDATE ON match
FOR EACH ROW
EXECUTE FUNCTION increase_coach_experience();