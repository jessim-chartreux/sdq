Config = Config or {}

Config.Webhooks = {
	INVENTORIES	= {
		INVENTORY_CREATE		= "https://discord.com/api/webhooks/1223139014299881502/W-Y64fJwhzzA6uLq7UJkHIvl5utFsI4PCzEFPKS7tOXRuOB8siwXclLIJa88zC7OeUqB",
		INVENTORY_UPDATE		= "https://discord.com/api/webhooks/1223139441493676082/prKQjItkzyWKJ8M7iAH6_h2pGKH1AIVvlo8WXtJ6m35GLV9JGkfGmuhLfIQIXHO1wiFn",
		INVENTORY_DELETE		= "https://discord.com/api/webhooks/1223139605424115784/xAE1TqUTfOe_0Y_P7qzIzRExoMmtwdUM6SfSVa_1alCXkNvovpQR5ZbU2ShuRJmsSzwr",
		ITEM_REMOVE				= "https://discord.com/api/webhooks/1223065450867331082/w10OTbcIu5eKSRkID1VdrCYhwswxteKSfdb0juUShGtgtKXGs7tzOdoJcehbBTUxtwIV",
		ITEM_CREATE				= "https://discord.com/api/webhooks/1223065541971808306/_xAvedZFQrsnMp4E1fwpPhxthY9H6vAUE92elZOZ1Q8gvigpPvTgKq4n8VQo2upDXaQR",
		ITEM_UPDATE				= "https://discord.com/api/webhooks/1223142089009922058/tzOCDM7xcPVZeIKXUggoQKYU1O0w5uMKHEjkohKODwVlHp2cblLJiMfyVX4MJKo7zTJT",
		ITEM_THROW				= "https://discord.com/api/webhooks/1223065612998279329/EBjDO0Yr1OS5x-AXrzmn4hiRhay44zr_dj9SCcpn4eeZf5gKhfqdubv2Xd7Xcpp1aS3B",
		ITEM_GIVE				= "https://discord.com/api/webhooks/1223065729008537620/xjj-s4DBUwnD7KEiBV72dWpgHfjvLJGLiRE8rwJ6hm0V0DQciS0lVDwcMIgCxzJ7lwX4",
		ITEM_MOVE 				= "https://discord.com/api/webhooks/1223144112115679332/6F7Gn71t1Y_z-7TFzIsKtaL3-21EezJ9a2U3nEiLJQ-h-KynxvdX35KPaepyLU5B-iIr",
		ITEM_ADD				= "https://discord.com/api/webhooks/1223065805026234458/xAIHT1AibBinw56tqIrs_XagvUP2fMVS7RAqYNf2blVR1dI7p0pduCh-qRbUk_YPRESN",
	},

	PROPERTIES	= {
		CREATE					= "https://discord.com/api/webhooks/1223066152843083847/US6i2-Df6C_L3jK7j0Ku-3jbZRkEyziEebXNqHbZU4_QO-T4lJc2AgBBpjekm8X0Cspu",
		DELETE					= "https://discord.com/api/webhooks/1223066060551491644/pgy358OBuBKCtQuA8gfEZyIOSobkL4vI1bYI-m5L_KufliqHZePZEVrGtFPOEKf8ohAn",
		UPDATE					= "https://discord.com/api/webhooks/1223164632613523536/pEC3TlgbkFyTBsHXtqAOj8ekC4f-QvB1MGaeDLvP0MTm4fxerbnNtxWt84NRe5zsyp47",
		ENTER					= "https://discord.com/api/webhooks/1223066217086980176/WId-Zbfx9QC5gE_Q7F5FLW98gyjiDYmTZ4EL3HslH8QcWnhBrZjMaLx8gpTr0HmZWSTY",
		LEAVE					= "https://discord.com/api/webhooks/1223066295424253992/yUVGClHkhxEP1L6bSkfWBgUJGsrPBdcgM4j7OF-PD-IsZFoug6AOhcYeuhhunMdYkdcb",
	},

	SOCIETIES	= {
		SOCIETY_UPDATEGRADE		= "https://discord.com/api/webhooks/1223150052114042991/uzIeC_1fb8XCEIYlpqnZn3PtJKMsyvdcdY92vibT7VfmBGynGE9UNv67T2-InRE1eaA7",
		EMPLOYEES_SETGRADE		= "https://discord.com/api/webhooks/1223066776326246523/L-2wGPI4PLFNx4Ci61BvdVRzGLqusmOACreIh4G_gsuGHJfNoIqBtr1ChD8HFBPtJ61l",
		SOCIETY_ANNOUNCE		= "https://discord.com/api/webhooks/1260990616691675237/_CydqguElDEvZHsbrpI0tq48-IrRhDUD2bAz7XbI0B2xhA5SxHvpHx0-WqJlRw2HW-Ve",
		SOCIETY_ADDGRADE		= "https://discord.com/api/webhooks/1223149328332357654/8YIFggCsu_8HFUzOTL0lIPZWUrQyLkEavXkYwKvvrP5BK_64orriq6l9BZc3-M9zPNi-",
		SOCIETY_DELGRADE		= "https://discord.com/api/webhooks/1223149662299750410/HgRNlYSSY9bazRAKDGQsUEUSJnU5pPAAJSsu5zrSYysrwFd6l9oxI-KcItxhilI_tCnJ",
		EMPLOYEES_REMOVE		= "https://discord.com/api/webhooks/1223067187284279419/yB-5O8iZz07F6Lot3FENYBnxO1Kb4QqmTyVffRnBHnYl23t6hK_UG11TFsqolTj4BTw6",
		DISPATCH_ACTION			= "https://discord.com/api/webhooks/1223067296600297542/VrIMTQrTthPYxFFsy0pqXlzhymuUCfqTkifFylEQPRHgUfNHI5X5lsuSA2jIudosfjYd",
		SOCIETY_CREATE			= "https://discord.com/api/webhooks/1223149753961943110/fuk2uHQLjvp5udTIaQmlgarAg7PLioKr4PF5v30RcB3aPV3YPM6wa4Ov-Fn0Z0eK_Mdl",
		SOCIETY_DELETE			= "https://discord.com/api/webhooks/1223149802380853320/BZ0JOj_XIRfBeqTiGFboNENhphAyGUs3DHk_DLTdn5ZK8l582pKeT35yI0OzToN9_zVt",
		SOCIETY_UPDATE			= "https://discord.com/api/webhooks/1223149867422060565/c71t16UNJyqxLjLLmp4SytpR7ZylH-YXobNtYoJqReVvAC8-_qKPdCNNoKwp63dw4-Sc",
		EMPLOYEES_ADD			= "https://discord.com/api/webhooks/1223067369274867756/C3M24cwez0jVKaxnOOUT3dcfno_fv8Ye0TLzcBfBrJsXX2eSeHqDl1_vkcASKRSer-Mo",
		DUTY_TOGGLE				= "https://discord.com/api/webhooks/1223067429786091642/A1ILhcFuQiLk7Z564UbmvK6ZIFNctHDTUyvf445oJK1vyYJUh-9iwIube5vGdJ25rmEj",
	},

	SECURITY 	= {
		ANTICHEAT				= "https://discord.com/api/webhooks/1223045490669781194/4_PZ0vOZIFX_l0Lq2ABhvyIQ8nGAOgCczpTODkItjhwquuck33heLiG0BbN0yFTvjLjn",
		EVENTS 					= "https://discord.com/api/webhooks/1223046029843365888/LNaslkprQUN6GLT1F5Rhtyoj9w7wn0yFsYQiouEb4NeWcVZZnWAMGzUOPmtPwW0hTA8v",
	},

	VEHICLES	= {
		INDICATOR_LIGHTS		= "https://discord.com/api/webhooks/1260989056771424367/4CxYJ0QjZhGIoUfQUdRRwzSn2MNn1bl6COnOvQ-nCVB_CWVBE0LQ-1ma3KOeD5bBO9MI",
		TOGGLE_WINDOW			= "https://discord.com/api/webhooks/1260989104628437042/fALjZnBlnc4IqFcg9HUAf3wRERRxSmnXDyZJzmPgB7puzhPXtEKaZyqQ28OelgVcdCvG",
		TOGGLE_DOOR				= "https://discord.com/api/webhooks/1260989167131955302/1hoeWd_L3opbhSHXyHaMU4mT434GaDNCmBOUSBS1UwijFRHgPmgTE1S7hfnUW0Si_GRr",
		LOCK_DOORS				= "https://discord.com/api/webhooks/1260989221494194176/PfyRzS-DtvZmyuLxrcsCHP9pCIgHlBA-_Hpp2rO3LKYhoZcI7Q4tbNWhjbuAAInbkp97",
		UNCOVER					= "https://discord.com/api/webhooks/1223067546664833104/C3bWPE-EExsRi6JYZts73arrwE_67yqTUcfurLpsxlbZxJPcLEBDaR0TdYXyRov5Q__n",
		CREATE					= "https://discord.com/api/webhooks/1223067663098581082/qkXesuPBD0bcYri0vfym2rKzIfcuoejYki0-9Av0e55UpqgM2jE7JwhAPeDACHFeWNOg",
		DELETE					= "https://discord.com/api/webhooks/1223067703510564985/0SEv7aHXdKTEN5b9tkCEcS-uzQIMKN-xRi0OugNJZDpoAN3KNSwa5iXRX5aabqXqvFOQ",
		REPAIR					= "https://discord.com/api/webhooks/1260989270647377953/Thr3AhYqyO7dVivGKDSv-i6s0_09MxaYD6EJAeLPGmwc255WpaceE9Lfcq43oirXo6IY",
		REFILL					= "https://discord.com/api/webhooks/1260989322296037470/aLT7zHOx4LAe8_Ns6WJcNHPSOIUEDC64phALYdymLh45-e099-w3tGIeRilXAe2yEwJ0",
		ALARM					= "https://discord.com/api/webhooks/1260989377807515700/jwYy59mABx_6_F-mCwaCkqRx70A-d5Y4sZVm2bCHxaIIknZl-XgdwjgKbu87LAyel5Yo",
		CLEAN					= "https://discord.com/api/webhooks/1260989432597712968/Clrukj2vS9npxUvwko3w8N9Tz3O9AgdYi7dBzWthqFeuUbji1rPiAsTmNY6q2XFObiXh",
		COVER					= "https://discord.com/api/webhooks/1223067753997402173/usg6wd1Ig_oLX7u0ynXZ4rl3SgUtlVo5-9TEfbTLMBr2e5HxBCNZOpEe4mLJ4iENLj7i",
		FLIP					= "https://discord.com/api/webhooks/1260989485248942112/3PXFRQEWQQwQD4FoKf_ZE8j87Fo_MOx7DVxmqlh7S4PvH-TfjWwVMuWa2VLSLhODnFuC",
	},

	WEAPONS		= {
		UNEQUIP 				= "https://discord.com/api/webhooks/1223067895920066691/q2yQ5RieSMERzNcfkNWxLZjO8fMxV8-UD8L7F27JIPiYbfi6GWSSiYwVrOrrXB2afdNy",
		EQUIP 					= "https://discord.com/api/webhooks/1223067944054030398/1rDU_MltyeDAdVOEx9QUhZzabtddP30GaE70unKAz_ooDBG0WPSecCbTw9CK65hpNBn2",
		SHOOT 					= "https://discord.com/api/webhooks/1223068002732474458/4UjDhbqO0SeAAimOyUgOrE769M8DJjCT36Jtb-aTocLsnjGoKkeMGveRJ5Mie5-wSdId",
	},

	PLAYER 		= {
		CONNECT 				= "https://discord.com/api/webhooks/1223068311860805633/VXSiDSdHmJE-KmIgTc125tf6To6LVhWKRH5vJp-NXFJPajXg3sws_LKGN4XgaIN6dEPy",
		CREATE 					= "https://discord.com/api/webhooks/1223068359718080572/YrscLz9rGKbyfu7H9BoDhxAJPRdOfZYlg5ZSTxX4B_Vwp-1tQvZ5mDr8h2k6oFZzOuFg",
		DELETE 					= "https://discord.com/api/webhooks/1223068431587475527/3l1Es7Qo1HywIXC6ncpn3PRHJpOQYoV-J0Y2pQBseHuHRgO5a046EUtV03ydrOJ3OGYK",
		REVIVE 					= "https://discord.com/api/webhooks/1223068488269172909/hHhmSYI6DNxRw6gxUpHr6aTYdxPfZGdTy1c_nKEuLL9NZHhyKw6BlBBnUoaA3Drvk9CF",
		SWITCH 					= "https://discord.com/api/webhooks/1223068551078875176/vYmaIKsqX7QxgJ9Epw3Ugojm0W37Q4OsO8hR15XISb9D_VTnIjbD4QLvLToQewBc1FUR",
		UPDATE 					= "https://discord.com/api/webhooks/1223068613167157278/d4FPPojBzqB6vcnENkYjaa2t-8HVmPR6tJyS1isqSMSeM4I4DNAHQR4IqizmGoqE5Sas",
		LEAVE					= "https://discord.com/api/webhooks/1223068669765091418/jcVqdQGkIImCFHYm2nIK44MoS_vnEOVQVWNTa7YXIBcOi4_WAN4jRWbqVFp811rvOsh6",
		DIE 					= "https://discord.com/api/webhooks/1223068729517019187/Z0drT_aaLfQtLKezXSkD26UiLSuzyHjswagtUF8ro0Db1Pi2OAZdkZzFTO_5WJIJr11Y",
		ME 						= "https://discord.com/api/webhooks/1261366638926889161/paC5yNzeYuUX_SXpXx1ZZxNzI8qnVF3edYRCKTLHC2oCiS8cU0JkTePm997PmIXhKRNP",
	},

	BANK		= {
		ACCOUNT_CREATE			= "https://discord.com/api/webhooks/1223068828464844942/dUEo4a2dLH70ScxEjvpfyGBlxTmHNe6TJGVv6cZCkie1SIMuLZwNS2j2kyiCJpBNNR19",
		REMOVE_BILL				= "https://discord.com/api/webhooks/1223157525583626240/Kg6A4UfdIMrZGkqdM_k8wbV627N-6-3MnhCSj4LTp231DipsPrElVQGGaU2HmNhvuaNq",
		ADD_BILL				= "https://discord.com/api/webhooks/1223157636430696550/l2rC-FTLbzjispLN5tUZuKA3-zPwKZn98uXiWcqaVKgDophcNESggfAtGz3-PPoBntdx",
		TRANSFER 				= "https://discord.com/api/webhooks/1223070383192674335/wLlW_VB2GYYgodMFwCSocgv5fpv3dPsRlNGr35DuTFPBfMuVzDK8_wmNVUqP4Bdyucsv",
		WITHDRAW 				= "https://discord.com/api/webhooks/1223069613236158595/aHjDSBZ1wrwhZk4SBV0RLeqhlLvbJmlwQIzRutHFeQ7dL8ybl_OhtSPNXjubA93DqD0q",
		DEPOSIT 				= "https://discord.com/api/webhooks/1223070776911990836/C8h4fvCafyp-ctexWIJ7O2lph9ieVWLbQkZpwqj-8uKOfy93n3cw9Q1MQZauDJAEzFPS",
		DELETE					= "https://discord.com/api/webhooks/1223158530119303239/P4RqOsyght2NNr_B9gIioOw4ITsr8EP0UlXx8SXFylip8fL_SVDILRR4u60pz8jDQMGo",
		UPDATE					= "https://discord.com/api/webhooks/1223158150195187732/yYNIO0uekEcfbsAn-O8-6RQd-5EATCgifxJgVGSQAAcS-OVA1XvBcQgpCuAMPxoJXBtX",
	},

	ILLEGAL 	= {
		DRUG_SELLING			= "https://discord.com/api/webhooks/1260992029228273784/1JhlFU2WWq2XPxZ9xqc6bPtSd7dtgeqRsdKPydqlH7zZBn_NjnWvwh-K6UfjOnKf8xS5",
		LABORATORY				= "https://discord.com/api/webhooks/1260992165987745834/LmEjubJsRJJFd3AOUXHSURzXtJdjC453Ghd0vlUBpIgfd65ExpxP14sbHdTB0RcMJkoV",
		MINIMARKET				= "https://discord.com/api/webhooks/1260992093149593663/HClVBQ9JFzddUvGelQnQulpW7MmQdMTuTXMyo1f17JdnlUo8oC_BlogZ8EdaKowOrTt5",
		CONTAINER 				= "https://discord.com/api/webhooks/1260992270325514294/a4x4or1LytplELuooHiCzX4aUC1unGkANC_WvV076k0jMgn0URqJ1nGmtHy7h7gtbrKp",
		CARJACK 				= "https://discord.com/api/webhooks/1260992334896697384/-R0fJx7T19CaLeBtZ83vBYuax18JpYdYBA3c2g28HcZKPd17JlzGEoDKyJl49-aPNwEj",
		FLEECA 					= "https://discord.com/api/webhooks/1260992402429055041/7WH3BAov9s9j58lcCEuf0eKQYXSCRD3XH7ml14O5saVCLoVwcFY04mhLoAFUIRQ-WToK",
		ORDER 					= "https://discord.com/api/webhooks/1260993925351604256/vsVd6CwBGm-9P4ECc_rdhcgYWPv0nBw1Rm8SzDuHZD2gwx8S5tJ0nqBA9CaM1usnymf6",
		WEED 					= "https://discord.com/api/webhooks/1260992458058371083/YAhUoclZB5ughCUiD0A_vHdV2ILKqfzYLnQLfIlZ2ovWrG7ZyrQO576z9rj-v0veHYEG",
		ATM						= "https://discord.com/api/webhooks/1260992515339849810/h3Q_jauj9bC-oBUyJ69B1ynn_PHa-ggY2DqRa4ZZCQWkQcShZeU2ElfKSh5bxjVSuGcO",
	},

	STAFF		= {
		LOCK_UNLOCK_CHARACTER	= "https://discord.com/api/webhooks/1240366060763353229/GbLtAoxT7y-07-QOSNq4xgh8l03qeuZOCjBMsfSFQ8DHfk1TyVaFWYdTf0bKpO_OkakR",
		CHANGE_PHONE_NUMBER		= "https://discord.com/api/webhooks/1240365983429034055/r-ifs_voVCRgm9zsZ21ikYp4xvTSsQEJeXKmoCo-WDjTnVIvxGmU9rB4lNMZYlx3kINd",
		CHANGE_SOURCE			= "https://discord.com/api/webhooks/1240365831829848145/6yu3ZOcAKdDtDPDvuRyY_4PLEx6NByU4xvENeNJ1u2bHqwVSI1j9ry8aWL8qVzh8gLd9",
		SEND_MESSAGE			= "https://discord.com/api/webhooks/1240365709620412527/5VO9mIfqJccXbZzvXl3tuwu3zLa_bxk5pwy4sHF0bk_YxYV23StXGrp0RVSXdlyt9CN1",
		MAKE_EM_FLY				= "https://discord.com/api/webhooks/1262973880126144614/-lhjLiYgHOrSvSTJOlHUY8DQ34NsglNAQQvGJtxF2VHovH6eeL79s9woh7FRVQn38-rD",
		INVISIBLE 				= "https://discord.com/api/webhooks/1260986031814086756/abyBLuHrnyPlFwB1YO3S1_Rp-DJrzLIdbBtDfHgt6zQO_a6mYFOJ_5p8uJC7KuIw1-Mw",
		SET_SLOTS				= "https://discord.com/api/webhooks/1240365653307686962/NMyknDCsTQVblamupeZnXU_T7XQy6KyZ6UO2oqPkgwp_56e-Xd6CM6e97V_4BbsyGWMU",
		RAGDOLL					= "https://discord.com/api/webhooks/1241322986238377994/F-5-ZglF-bwNR27i45wXcQkY_KRXKtWLdEyZZOSSoA1dZ8uTh0Hzd271lo5hiwiw_K2b",
		GODMODE					= "https://discord.com/api/webhooks/1260984416856047708/df5-2_sX_Yy0SP7Afkmbc_iH_jVGhWssYLHALk8k64tfCy5PAlOelh3vtmVQHwluw6MW",
		BRING					= "https://discord.com/api/webhooks/1240365589697134736/pxUKOww3E0TL2K4FydjFOf-6XhWCbwb6Uz9gt_dKiFbfjBiTUFMRm16wnN129JkvjbL3",
		BLIPS					= "https://discord.com/api/webhooks/1240365521636163635/jwqplL5Pbf69zXJK_fwPMtz3GBwjGOOpN7aZNgmh3yIQdMKTVzIFGvXs2YMVYb0IZ-Sj",
		EMOTE					= "https://discord.com/api/webhooks/1240365451725504592/EPM6VHF5-3lNv47VxOk7iBZH06mC7t1TmHeSTe28LZ9eUHq73DuN14U4-k5xQ_4lQhWQ",
		NAMES					= "https://discord.com/api/webhooks/1260986141344272397/ZXEG2VxceM1yATUhVshFgSh3a-EwbpaAGAR8Y5YWE_zeJkgUYa0RZ7FR6DvdEmIpGzL-",
		GOTO					= "https://discord.com/api/webhooks/1240365345664008313/ntLtkJDCZAizSf06syUD88FrGrrbkJP7GGeAeZZsEOnt5i-ROYBxRtiPykghCJ6oKuF1",
		WIPE					= "https://discord.com/api/webhooks/1240364420253614142/BX1NwL0jbgXn1mZW0QefxItKIGbYkJv-rNOGulFtoU4A_LTnMfWqtrGc-ZFaKTZTBcXT",
		KICK					= "https://discord.com/api/webhooks/1240365209814827038/v0WsfSzsRPRoXaQ0bVtEehli9TLqm0WZberzL5zEVLmlT6pC5u5viap10fGAjer2NlQ7",
		BAN						= "https://discord.com/api/webhooks/1240365270401286297/xNbvgVuHVjD8vXVratguZxVsebAZBqxta1yB2_kNlllBnChpzFKU5tP5WYMFNdKURXQu",
	},

	STATUS 						= "https://discord.com/api/webhooks/1262277160505180160/wBopQ0A_xTj3GrXyvhpleRp6l9IIe4EGuXQPgAT2-FU9xhe-OP9KmlNeAf5f1Rbt3cc6"
}
