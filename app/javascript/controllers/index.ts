import { application } from "./application"

import SortableController from "./sortable_controller"
import NewCardController from "./new_card_controller"
import CardEditorController from "./card_editor_controller"
import FlashController from "./flash_controller"
import PresenceController from "./presence_controller"

application.register("sortable", SortableController)
application.register("new-card", NewCardController)
application.register("card-editor", CardEditorController)
application.register("flash", FlashController)
application.register("presence", PresenceController)
