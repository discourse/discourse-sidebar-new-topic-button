import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import didUpdate from "@ember/render-modifiers/modifiers/did-update";
import { service } from "@ember/service";
import { gt } from "truth-helpers";
import CreateTopicButton from "discourse/components/create-topic-button";

export default class SidebarNewTopicButton extends Component {
  @service composer;
  @service currentUser;
  @service siteSettings;
  @service router;

  @tracked category;
  @tracked tag;

  get shouldRender() {
    return this.currentUser && !this.router.currentRouteName.includes("admin");
  }

  get canCreateTopic() {
    return this.currentUser?.can_create_topic;
  }

  get draftCount() {
    return this.currentUser?.get("draft_count");
  }

  get createTopicTargetCategory() {
    if (this.category?.canCreateTopic) {
      return this.category;
    }

    if (this.siteSettings.default_subcategory_on_read_only_category) {
      return this.category?.subcategoryWithCreateTopicPermission;
    }
  }

  @action
  createNewTopic() {
    this.composer.openNewTopic({
      category: this.category,
      tags: this.tag?.id,
    });
  }

  @action
  getCategoryandTag() {
    this.category = this.router.currentRoute.attributes?.category || null;
    this.tag = this.router.currentRoute.attributes?.tag || null;
  }

  <template>
    {{#if this.shouldRender}}
      <div
        class="sidebar-new-topic-button__wrapper"
        {{didInsert this.getCategoryandTag}}
        {{didUpdate this.getCategoryandTag this.router.currentRoute}}
      >
        <CreateTopicButton
          @canCreateTopic={{this.canCreateTopic}}
          @action={{this.createNewTopic}}
          @label="topic.create"
          @btnId="create-topic-sidebar"
          @btnClass="btn-default sidebar-new-topic-button"
          @showDrafts={{gt this.draftCount 0}}
        />
      </div>
    {{/if}}
  </template>
}
