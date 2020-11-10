# DB設計

## user table
| Column      | Type   | Options     |
|-------------|--------|-------------|
| user_name   | string | null:false  |
| password    | string | null:false  |
| email       | string | unique:true |

### Association
- has_many :memos
- has_many :fav_memos


## memo table
| Column     | Type       | Options           |
|------------|------------|-------------------|
| memo_text  | text       | null:false        |
| user       | references | foreign_key: true |

## Association
- belongs_to :user
- has_many :fav_memos


## fav_memo table
| Column | Type       | Options           |
|--------|------------|-------------------|
| user   | references | foreign_key: true |
| memo   | references | foreign_key: true |

## Association
- belongs_to :user
- belongs_to :memo
