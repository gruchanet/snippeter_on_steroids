SELECT p.name, i.name FROM player p
  INNER JOIN player_has_item pi ON pi.id_player = p.id
  INNER JOIN item i ON pi.id_item = i.id;