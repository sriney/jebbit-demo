#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes
#= require ./router
#= require_self
#= require ./fixtures

App.Store = DS.Store.extend(
  revision: 12
  adapter: "DS.RESTAdapter" # "DS.FixtureAdapter"
)

App.Site = DS.Model.extend(
  name: DS.attr("string")
  author: DS.attr("string")
  img_url: DS.attr("string")
  landing_url: DS.attr("string")
  publishedAt: DS.attr("date")
)

App.SitesRoute = Ember.Route.extend(
  model: ->
    App.Site.find()
)

# See Discussion at http://stackoverflow.com/questions/14705124/creating-a-record-with-ember-js-ember-data-rails-and-handling-list-of-record
App.SitesController = Ember.ArrayController.extend(
  sortProperties: [ "id" ]
  sortAscending: false
  filteredContent: (->
    content = @get("arrangedContent")
    content.filter (item, index) ->
      not (item.get("isNew"))
  ).property("arrangedContent.@each")
)

App.SitesNewRoute = Ember.Route.extend(
  model: ->
    App.Site.createRecord(publishedAt: new Date(), author: "current user")
)

App.SitesNewController = Ember.ObjectController.extend(
  save: ->
    @get('store').commit()

  cancel: ->
    @get('content').deleteRecord()
    @get('store').transaction().rollback()
    @transitionToRoute('sites')

  transitionAfterSave: ( ->
    # when creating new records, it's necessary to wait for the record to be assigned
    # an id before we can transition to its route (which depends on its id)
    @transitionToRoute('site', @get('content')) if @get('content.id')
  ).observes('content.id')
)

App.SiteController = Ember.ObjectController.extend(
  isEditing: false
  edit: ->
    @set "isEditing", true

  delete: ->
    if (window.confirm("Are you sure you want to delete this site?"))
      @get('content').deleteRecord()
      @get('store').commit()
      @transitionToRoute('sites')

  doneEditing: ->
    @set "isEditing", false
    @get('store').commit()
)
App.IndexRoute = Ember.Route.extend(redirect: ->
  @transitionTo "sites"
)
Ember.Handlebars.registerBoundHelper "date", (date) ->
  moment(date).fromNow()

window.showdown = new Showdown.converter()

Ember.Handlebars.registerBoundHelper "markdown", (input) ->
  new Ember.Handlebars.SafeString(window.showdown.makeHtml(input)) if input # need to check if input is defined and not null

App.Router.map ->
  @resource "sites_view", ->
    @resource "site",
      path: ":site_id"
  @resource "about"
  @resource "sites", ->
    @resource "site",
      path: ":site_id"
    @route "new"
