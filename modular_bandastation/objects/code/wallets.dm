/obj/item/storage/wallet/wallet_NT
	name = "leather wallet NT"
	desc = "Ваш кошелек настолько шикарен, что с ним вы выглядите просто потрясающе."
	icon = 'modular_bandastation/objects/icons/wallets.dmi'
	icon_state = "wallet_NT"
	worn_icon = 'modular_bandastation/objects/icons/onbody/id.dmi'
	worn_icon_state = "wallet_NT"

/obj/item/storage/wallet/wallet_NT/update_overlays()
	. = ..()
	cached_flat_icon = null
	if(!front_id)
		return
	. += mutable_appearance(front_id.icon, front_id.icon_state)
	. += front_id.overlays
	. += mutable_appearance(icon, "wallet_NT_overlay")

/obj/item/storage/wallet/wallet_NT/update_label()
	if(front_id)
		name = "leather NT wallet displaying [front_id]"
		return
	name = "leather NT wallet"

/obj/item/storage/wallet/wallet_USSP_1
	name = "leather USSP wallet"
	desc = "Говорят, такие кошельки в СССП носят исключительно для зажигалок."
	icon = 'modular_bandastation/objects/icons/wallets.dmi'
	icon_state = "wallet_USSP_1"
	worn_icon = 'modular_bandastation/objects/icons/onbody/id.dmi'
	worn_icon_state = "wallet_USSP_1"

/obj/item/storage/wallet/wallet_USSP_1/update_overlays()
	. = ..()
	cached_flat_icon = null
	if(!front_id)
		return
	. += mutable_appearance(front_id.icon, front_id.icon_state)
	. += front_id.overlays
	. += mutable_appearance(icon, "wallet_USSP_1_overlay")

/obj/item/storage/wallet/wallet_USSP_1/update_label()
	if(front_id)
		name = "leather USSP wallet displaying [front_id]"
		return
	name = "leather USSP wallet"

/obj/item/storage/wallet/wallet_USSP_2
	name = "leather USSP wallet"
	desc = "Говорят, такие кошельки в СССП носят исключительно для зажигалок."
	icon = 'modular_bandastation/objects/icons/wallets.dmi'
	icon_state = "wallet_USSP_2"
	worn_icon = 'modular_bandastation/objects/icons/onbody/id.dmi'
	worn_icon_state = "wallet_USSP_2"

/obj/item/storage/wallet/wallet_USSP_2/update_overlays()
	. = ..()
	cached_flat_icon = null
	if(!front_id)
		return
	. += mutable_appearance(front_id.icon, front_id.icon_state)
	. += front_id.overlays
	. += mutable_appearance(icon, "wallet_USSP_2_overlay")

/obj/item/storage/wallet/wallet_USSP_2/update_label()
	if(front_id)
		name = "leather USSP wallet displaying [front_id]"
		return
	name = "leather USSP wallet"

/obj/item/storage/wallet/wallet_wyci
	name = "W.Y.C.I. wallet"
	desc = "Кошелек, законодателя моды WYCI,\
	украшен золотой пуговицей cшит позолочеными и платиновыми нитями, сверх прочный.\
	И сверх модный. И сверх дорогой. И сшит по принципу WYCI."
	icon = 'modular_bandastation/objects/icons/wallets.dmi'
	icon_state = "wallet_wyci"
	worn_icon = 'modular_bandastation/objects/icons/onbody/id.dmi'
	worn_icon_state = "wallet_wyci"

/obj/item/storage/wallet/wallet_wyci/update_overlays()
	. = ..()
	cached_flat_icon = null
	if(!front_id)
		return
	. += mutable_appearance(front_id.icon, front_id.icon_state)
	. += front_id.overlays
	. += mutable_appearance(icon, "wallet_wyci_overlay")

/obj/item/storage/wallet/wallet_wyci/update_label()
	if(front_id)
		name = "W.Y.C.I. wallet displaying [front_id]"
		return
	name = "W.Y.C.I. wallet"
