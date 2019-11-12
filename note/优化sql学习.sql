> 
SELECT 
  * 
FROM
  rank_user AS rankUserLEFT 
  JOIN rank_user_level AS userLevel 
    ON rankUser.id = userLevel.user_idLEFT 
  JOIN rank_product AS product 
    ON userLevel.new_level = product.level_idLEFT 
  JOIN rank_product_fee AS fee 
    ON userLevel.fee_id = fee.fee_idLEFT 
  JOIN rank_user_login_stat AS userLoginInfo 
    ON rankUser.id = userLoginInfo.user_idORDER BY rankUser.create_time DESCLIMIT 10 OFFSET 0 
    
SELECT 
  * 
FROM
  rank_user AS rankUserLEFT 
  JOIN rank_user_level AS userLevel 
    ON rankUser.id = userLevel.user_idLEFT 
  JOIN rank_product AS product 
    ON userLevel.new_level = product.level_idLEFT 
  JOIN rank_product_fee AS fee 
    ON userLevel.fee_id = fee.fee_idLEFT 
  JOIN rank_user_login_stat AS userLoginInfo 
    ON rankUser.id = userLoginInfo.user_id -- ORDER BY	-- rankUser.create_time DESCLIMIT 10 OFFSET 0 
    
SELECT 
  * 
FROM
  rank_user AS rankUserLEFT 
  JOIN rank_user_level AS userLevel 
    ON rankUser.id = userLevel.user_id -- LEFT JOIN rank_product AS product ON userLevel.new_level = product.level_id-- LEFT JOIN rank_product_fee AS fee ON userLevel.fee_id = fee.fee_idLEFT JOIN rank_user_login_stat AS userLoginInfo ON rankUser.id = userLoginInfo.user_idORDER BY	rankUser.create_time DESCLIMIT 10 OFFSET 0 
    
    
SELECT 
  rankUser.id,
  rankUser.qq,
  rankUser.phone,
  rankUser.regip,
  rankUser.channel,
  rankUser.create_time,
  rankUser.qudao_key,
  rankUser.qq_openid,
  rankUser.wechat_openid,
  userLevel.recommend_count,
  userLevel.end_time,
  userLevel.new_level,
  userLevel.`level`,
  userLevel.new_recommend_count,
  userLevel.`is_limited`,
  (
    CASE
      WHEN userLevel.new_level > 1 
      THEN 1 
      ELSE 0 
    END
  ) is_official_user,
  (
  SELECT 
    product_name 
  FROM
    rank_product 
  WHERE level_id = userLevel.new_level
  ) product_name,
  (
  SELECT 
    period 
  FROM
    rank_product_fee 
  WHERE fee_id = userLevel.fee_id
  ) period,
  userLoginInfo.last_login,
  userLoginInfo.login_count,
  userLoginInfo.login_seconds 
FROM
  rank_user AS rankUser 
  LEFT JOIN rank_user_level AS userLevel 
    ON userLevel.user_id = rankUser.id 
  LEFT JOIN rank_user_login_stat AS userLoginInfo 
    ON rankUser.id = userLoginInfo.user_id ORDER BY rankUser.create_time DESC LIMIT 10 OFFSET 0 
	
	spring cloud
	redis 
	sql
	多线程
	