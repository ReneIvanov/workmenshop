require 'rails_helper'

RSpec.describe WorksController, type: :controller do
  describe "- GET #index" do
    before(:each) { @works_in_database = create_list(:work, 5) }
    let(:serialized_works_in_database){ serialize(@works_in_database) }

    context " - HTML format" do
      before(:each) {get :index}
      let(:serialized_returned_works){ serialize(assigns(:works)) }

      it_behaves_like "response status", 200
      it_behaves_like "render template", :index

      it "- should returns a list of works." do
        expect(compare_arrays_of_hashes(serialized_returned_works, serialized_works_in_database)).to be true
      end
    end

    context " - JSON format" do
      before(:each) {get :index, format: :json}

      it_behaves_like "response status", 200
      
      it "- should returns a list of works." do
        returned_works = parser(response.body)[:works]
        serialized_works_in_database = serialize(@works_in_database)

        expect(compare_arrays_of_hashes(returned_works, serialized_works_in_database)).to be true
      end
    end 
  end

  describe "- GET #show" do
    before(:each) {@requested_work = create :work}

    context " - HTML format" do
      before(:each) { get :show, params: { id: @requested_work.public_uid } }

      it_behaves_like "response status", 200
      it_behaves_like "render template", :show
  
      it "- should returns a work." do
        serialized_returned_work = serialize(assigns(:work))
        serialized_requested_work = serialize(@requested_work)

        expect(serialized_returned_work <= serialized_requested_work).to be true
      end
    end

    context " - JSON format" do
      before(:each) {get :show, params: { id: @requested_work.public_uid }, format: :json}

      it_behaves_like "response status", 200

      it "- should returns a work." do
        serialized_returned_work = parser(response.body)[:work].first
        serialized_requested_work = serialize(@requested_work)
        
        expect(serialized_returned_work).to match(serialized_requested_work)
      end
    end
  end

  describe "- GET #new" do 
    context " - HTML format" do
      before(:each) { get :new }
      
      it_behaves_like "response status", 200
      it_behaves_like "render template", :new

      it "- should returns a new work." do
        expect(assigns(:work).public_uid).to eq(nil)
      end
    end

    context " - JSON format" do
      before(:each) {get :new, format: :json}

      it_behaves_like "response status", 200

      it "- should returns a new work." do
        serialized_returned_work = parser(response.body)[:work].first
        
        expect(serialized_returned_work[:id]).to be nil 
      end
    end
  end

  describe "- GET #registration_new" do 
    before(:each) do
      @user = create(:user)
      create_list(:work, 4)
    end
 
    context " - user signed in" do
      before(:each) { sign_in(@user) }

      context " - HTML format" do
        before(:each) { get :registration_new }
        
        it_behaves_like "response status", 200
        it_behaves_like "render template", :registration_new
  
        it "- should returns a new work." do
          expect(assigns(:work).public_uid).to eq(nil)
        end

        it "- should returns all works." do
          serialized_returned_works = serialize(assigns[:works])
          serialized_works = serialize(Work.all)

          expect(compare_arrays_of_hashes(serialized_returned_works, serialized_works)).to be true
        end
      end
  
      context " - JSON format" do
        before(:each) {get :registration_new, format: :json}
  
        it_behaves_like "response status", 200

        it "- should returns all works." do
          response_body = parser(response.body)
          serialized_all_works = serialize(Work.all)

          expect(compare_arrays_of_hashes(response_body[:works], serialized_all_works)).to be true
        end
      end
    end

    context " - without signed in user" do
      context " - HTML format" do
        before(:each) { get :registration_new }
 
        it_behaves_like "unauthorized examples HTML"  
  
        it "- shouldn't returns a work nor works" do
          expect(assigns(:work)).to eq(nil)
          expect(assigns(:works)).to eq(nil)
        end
      end
 
      context " - JSON format" do
        before(:each) {get :registration_new, format: :json}
 
        it_behaves_like "unauthorized examples JSON" 
 
        it "- shouldn't returns a works" do
          response_body = parser(response.body)

          expect(response_body.keys).to eq([:notice])
        end
      end
    end
  end

  describe "- GET #edit" do
    before(:each) {@requested_work = create :work}
 
    context " - admin signed in" do
      before(:each) {sign_in_admin}
 
      context " - HTML format" do
        before(:each) { get :edit, params: { id: @requested_work.public_uid } }
 
        it_behaves_like "response status", 200
        it_behaves_like "render template", :edit
  
        it "- should returns a work." do
          serialized_returned_work = serialize(assigns(:work))
          serialized_requested_work = serialize(@requested_work)
 
          expect(serialized_returned_work).to eql(serialized_requested_work)
        end
      end
 
      context " - JSON format" do
        before(:each) {get :edit, params: { id: @requested_work.public_uid }, format: :json}
 
        it_behaves_like "response status", 200
 
        it "- should returns a work." do
          serialized_returned_work = parser(response.body)[:work].first
          serialized_requested_work = serialize(@requested_work)
 
          expect(serialized_returned_work <= serialized_requested_work).to be true
        end
      end
    end
 
    context " - without signed in user" do
      context " - HTML format" do
        before(:each) { get :edit, params: { id: @requested_work.public_uid } }
 
        it_behaves_like "unauthorized examples HTML"  
  
        it "- shouldn't returns a work." do
          expect(assigns(:work)).to eq(nil)
        end
      end
 
      context " - JSON format" do
        before(:each) {get :edit, params: { id: @requested_work.public_uid }, format: :json}
 
        it_behaves_like "unauthorized examples JSON" 
 
        it "- shouldn't returns a work." do
          response_body = parser(response.body)

          expect(response_body.keys).to eq([:notice])
        end
      end
    end
  end

  describe "- GET #registration_edit" do
    before(:each) do
      @user = create(:user, :with_works, works_count: 2)
      create_list(:work, 2)
    end
 
    context " - user signed in" do
      before(:each) { sign_in(@user) }
 
      context " - HTML format" do
        before(:each) { get :registration_edit }
 
        it_behaves_like "response status", 200
        it_behaves_like "render template", :registration_edit
  
        it "- should returns a new work." do
          expect(assigns[:work].id).to be nil
        end

        it "- should returns a user's existed_works_id." do
          expect(assigns[:existed_works_id]).to eql(@user.work_ids)
        end
      
        it "- should returns all works." do
          serialized_returned_works = serialize(assigns[:works])
          serialized_works = serialize(Work.all)

          expect(compare_arrays_of_hashes(serialized_returned_works, serialized_works)).to be true
        end
      end
 
      context " - JSON format" do
        before(:each) {get :registration_edit, format: :json}
 
        it_behaves_like "response status", 200
 
        it "- should returns a user's existed_works_id." do
          response_body = parser(response.body)

          expect(response_body[:existed_work_ids]).to eql(@user.work_ids)
        end
      
        it "- should returns all works." do
          response_body = parser(response.body)
          serialized_all_works = serialize(Work.all)

          expect(compare_arrays_of_hashes(response_body[:all_works], serialized_all_works)).to be true
        end
      end
    end
 
    context " - without signed in user" do
      context " - HTML format" do
        before(:each) { get :registration_edit }
 
        it_behaves_like "unauthorized examples HTML"  
  
        it "- shouldn't returns a work, works nor existed_works_id." do
          expect(assigns(:work)).to eq(nil)
          expect(assigns(:works)).to eq(nil)
          expect(assigns(:existed_works_id)).to eq(nil)
        end
      end
 
      context " - JSON format" do
        before(:each) {get :registration_edit, format: :json}
 
        it_behaves_like "unauthorized examples JSON" 
 
        it "- shouldn't returns a all_works nor existed_work_ids." do
          response_body = parser(response.body)

          expect(response_body.keys).to eq([:notice])
        end
      end
    end
  end

  describe " - POST #create" do 
    before(:each) do
      @user = create(:user, :with_workmen_account)
      @work_attributes = attributes_for(:work)
      @work = build(:work, @work_attributes)
    end
      
    context " - user signed in" do
      before(:each) {sign_in(@user)}

      context " - work is saved into database" do
        context " - HTML format" do
          before(:each) { post :create, params: { work: @work_attributes } }
    
          it_behaves_like "response status", 302
          it_behaves_like "notice", "Work was successfully created."
          it_behaves_like "redirect to", :root
    
          it " - should returns a new created work." do
            serialized_returned_work = serialize(assigns(:work))
            serialized_work = serialize(@work)
            serialized_work[:public_uid] = serialized_returned_work[:public_uid]

            expect(serialized_returned_work).to eq(serialized_work)
          end

          it " - created work should be saved into database" do
            serialized_work = serialize(@work)
            serialized_work[:public_uid] = assigns(:work).public_uid
            serialized_saved_work = serialize(Work.find(assigns(:work).id))

            expect(serialized_saved_work).to eq(serialized_work)
          end
        end
    
        context " - JSON format" do
          before(:each) { post :create, format: :json, params: { work: @work_attributes } }
          
          it_behaves_like "response status", 201
          
          it " - should return a notice" do
            response_body = parser(response.body)
            expect(response_body[:notice]).to eq("Work was successfully created.")
          end
          
          it " - should returns a new created work." do
            serialized_returned_work = parser(response.body)[:work].first
            serialized_work = serialize(@work)
            serialized_work[:id] = serialized_returned_work[:id]
            serialized_work[:public_uid] = serialized_returned_work[:public_uid]
    
            expect(serialized_returned_work <= serialized_work). to be true
          end
        end
      end
  
      context " - work isn't saved into database" do
        before(:each) do     #this is reason why work will not be saved into database
          @work.title = "" 
          @work_attributes[:title] = ""
        end
  
        context " - HTML format" do
          before(:each) {post :create, params: { work: @work_attributes } }
           
          it_behaves_like "response status", 200
          it_behaves_like "notice", "Work was not created."
          it_behaves_like "render template", :new
          
          it " - should return unsaved work" do
            @work.id = 1  #because we need to compare with assigns(:user) and for this is necessary to have some id
            assigns(:work).id = 1
            serialized_work = serialize(@work)
            serialized_returned_work = serialize(assigns(:work))
  
            expect(serialized_returned_work).to eq(serialized_work)
          end
        end
  
        context " - JSON format" do
          before(:each) { post :create, format: :json, params: { work: @work_attributes } }
    
          it_behaves_like "response status", 422
  
          it " - should return a notice" do
            expect(parser(response.body)[:notice]).to eq("Work was not created.")
          end
    
          it " - should returns a uncreated work." do
            response_body = parser(response.body)
            serialized_returned_work = response_body[:work].first
            serialized_work = serialize(@work)
    
            expect(response_body[:work].count).to eq(1)
            expect(response_body.keys).to eq([:work, :notice]) 
            expect(serialized_returned_work). to eq(serialized_work)
          end
        end
      end 
    end

    context " - without signed in user" do
      context " - HTML format" do
        before(:each) { post :create, params: { work: @work_attributes } }
 
        it_behaves_like "unauthorized examples HTML"  
  
        it "- shouldn't returns a work." do
          expect(assigns(:work)).to eq(nil)        end
      end
 
      context " - JSON format" do
        before(:each) { post :create, format: :json, params: { work: @work_attributes } }
 
        it_behaves_like "unauthorized examples JSON" 
 
        it "- shouldn't returns work." do
          response_body = parser(response.body)

          expect(response_body.keys).to eq([:notice])
        end
      end
    end
  end

  describe " - POST #registration_create" do 
    before(:each) do
      @user = create(:user, :with_workmen_account, :with_works, works_count: 2)
      @work_attributes = attributes_for(:work)
      @work = build(:work, @work_attributes)
    end
      
    context " - user signed in" do
      before(:each) {sign_in(@user)}

      context " - new work is created" do
        before(:each) { post :registration_create, params: { work: @work_attributes, existed_works_id: @user.work_ids } }

        it " - work should be added to user." do
          returned_work = assigns(:work)
          @user.reload

          expect(returned_work.users.count).to eq(1)
          expect(returned_work.users.first.id).to eq(@user.id)
          expect(@user.works.count).to eq(3)
        end
      end

      context " - new work is not created" do
        before(:each) { post :registration_create, params: { work: {title: ""}, existed_works_id: @user.work_ids } }

        it " - work shouldn't be added to user." do
          @user.reload

          expect(@user.works.count).to eq(2)
        end
      end

      context " - work is saved into database" do
        context " - HTML format" do
          before(:each) { post :registration_create, params: { work: @work_attributes, existed_works_id: @user.work_ids } }
    
          it_behaves_like "response status", 302
          it_behaves_like "notice", "Works have been set and new work has been created."
          it_behaves_like "redirect to", :root
    
          it " - should returns a new created work." do
            serialized_returned_work = serialize(assigns(:work))
            serialized_work = serialize(@work)
            serialized_work[:public_uid] = serialized_returned_work[:public_uid]

            expect(serialized_returned_work).to eq(serialized_work)
          end

          it " - created work should be saved into database" do
            serialized_work = serialize(@work)
            serialized_work[:public_uid] = assigns(:work).public_uid
            serialized_saved_work = serialize(Work.find(assigns(:work).id))

            expect(serialized_saved_work).to eq(serialized_work)
          end
        end
    
        context " - JSON format" do
          before(:each) { post :registration_create, format: :json, params: { work: @work_attributes, existed_works_id: @user.work_ids } }
          
          it_behaves_like "response status", 201
          
          it " - should return a notice" do
            response_body = parser(response.body)
            expect(response_body[:notice]).to eq("Works have been set and new work has been created.")
          end
          
          it " - should returns a new created work." do
            serialized_returned_work = parser(response.body)[:work].first
            serialized_work = serialize(@work)
            serialized_work[:id] = serialized_returned_work[:id]
            serialized_work[:public_uid] = serialized_returned_work[:public_uid]
    
            expect(serialized_returned_work <= serialized_work). to be true
          end
        end
      end
  
      context " - new work isn't saved into database" do
        before(:each) do     #this is reason why work will not be saved into database
          @work.title = "" 
          @work_attributes[:title] = ""
        end
  
        context " - HTML format" do
          before(:each) { post :registration_create, params: { work: @work_attributes, existed_works_id: @user.work_ids } }
           
          it_behaves_like "response status", 302
          it_behaves_like "notice", "Works have been set but new work has not been created."
          it_behaves_like "redirect to", :root
        end
  
        context " - JSON format" do
          before(:each) { post :registration_create, format: :json, params: { work: @work_attributes, existed_works_id: @user.work_ids } }
    
          it_behaves_like "response status", 201
  
          it " - should return a notice" do
            expect(parser(response.body)[:notice]).to eq("Works have been set but new work has not been created.")
          end
        end
      end 
    end

    context " - without signed in user" do
      context " - HTML format" do
        before(:each) { post :registration_create, params: { work: @work_attributes, existed_works_id: @user.work_ids } }
 
        it_behaves_like "unauthorized examples HTML"  
  
        it "- shouldn't returns a work." do
          expect(assigns(:work)).to eq(nil)
        end
      end
 
      context " - JSON format" do
        before(:each) { post :registration_create, format: :json, params: { work: @work_attributes, existed_works_id: @user.work_ids } }
 
        it_behaves_like "unauthorized examples JSON" 
 
        it "- shouldn't returns work." do
          response_body = parser(response.body)

          expect(response_body.keys).to eq([:notice])
        end
      end
    end
  end


  describe " - PUT #update" do 
    before(:each) do
      @created_work = create :work #save some work into database
      @loaded_work = Work.find(@created_work.id) #load work from database
      @modified_work = build :work
      @modified_work.id = @loaded_work.id #this work is modified work with same id like work in database
      @modified_work.public_uid = @loaded_work.public_uid #this work is modified work with same public_uid like work in database
    end

    context " - admin signed in" do
      before(:each) {sign_in_admin}

      context " - modified work is updated in database" do
        context " - HTML format" do
          before(:each) { put :update, params: { id: @loaded_work.public_uid, work: serialize(@modified_work) } } #update need to have :id in :params
    
          it_behaves_like "response status", 302
          it_behaves_like "notice", "Work was successfully updated."

          it " - should redirect to :show" do
            expect(response).to redirect_to("/works/#{@loaded_work.public_uid}")
          end
    
          it " - should returns a updated work." do
            serialized_returned_work = serialize(assigns(:work))
            serialized_modified_work = serialize(@modified_work)
            expect(serialized_returned_work).to eq(serialized_modified_work)
          end
    
          it " - wrok should be updated in database" do
            updated_work = Work.find(@modified_work.id)
            serialized_updated_work = serialize(updated_work)
            serialized_modified_work = serialize(@modified_work)

            expect(serialized_updated_work).to eq(serialized_modified_work)
          end
        end
    
        context " - JSON format" do
          before(:each) { put :update, format: :json, params: { id: @loaded_work.public_uid, work: serialize(@modified_work) } } #update need to have :id in :params
    
          it_behaves_like "response status", 200

          it " - should return a notice" do
            expect(parser(response.body)[:notice]).to eq("Work was successfully updated.")
          end
    
          it " - should returns a updated work." do
            response_body = parser(response.body)
            returned_work = response_body[:work].first
            serialized_modified_work = serialize(@modified_work)
    
            expect(response_body[:work].count).to eq(1)
            expect(response_body.keys).to eq([:work, :notice]) 
            expect(returned_work).to eq(serialized_modified_work)
          end

          it " - work should be updated in database" do
            updated_work = Work.find(@modified_work.id)
            serialized_updated_work = serialize(updated_work)
            serialized_modified_work = serialize(@modified_work)

            expect(serialized_updated_work).to eq(serialized_modified_work)
          end
        end
      end

      context " - modified work isn't updated in database" do
        before(:each) {@modified_work.title = ""} #this is reason why work will not be saved into database
       
        context " - HTML format" do
          before(:each) { put :update, params: { id: @loaded_work.public_uid, work: serialize(@modified_work) } } #update need to have :id in :params
    
          it_behaves_like "response status", 200
          it_behaves_like "render template", :edit
          it_behaves_like "notice", "Work was not updated."
    
          it " - should returns a modified work (but not saved into database)." do
            serialized_returned_work = serialize(assigns(:work))
            serialized_modified_work = serialize(@modified_work)
            expect(@serialized_returned_work).to eq(@serialized_modified_work)
          end
    
          it " - work shouldn't be updated in database" do
            serialized_not_updated_work = serialize(Work.find(@loaded_work.id))
            serialized_loaded_work = serialize(@loaded_work)
            expect(serialized_not_updated_work).to eq(serialized_loaded_work)
          end
        end
    
        context " - JSON format" do
          before(:each) { put :update, format: :json, params: { id: @loaded_work.public_uid, work: serialize(@modified_work) } } #update need to have :id in :params
    
          it_behaves_like "response status", 422

          it " - should return a notice" do
            expect(parser(response.body)[:notice]).to eq("Work was not updated.")
          end
    
          it " - should returns a modified work (but not saved into database)." do
            response_body = parser(response.body)
            returned_work = response_body[:work].first
            serialized_modified_work = serialize(@modified_work)

            expect(response_body[:work].count).to eq(1)
            expect(response_body.keys).to eq([:work, :notice]) 
            expect(returned_work).to eq(serialized_modified_work)
          end

          it " - work shouldn't be updated in database" do
            not_updated_work = Work.find(@loaded_work.id)
            serialized_not_updated_work = serialize(not_updated_work)
            serialized_loaded_work = serialize(@loaded_work)

            expect(serialized_not_updated_work).to eq(serialized_loaded_work)
          end
        end
      end  
    end

    context " - without signed in admin" do
      context " - HTML format" do
          before(:each) { put :update, params: { id: @loaded_work.public_uid, work: serialize(@modified_work) } } #update need to have :id in :params

        it_behaves_like "unauthorized examples HTML"  
  
        it "- should returns a unsaved work." do
          expect(assigns(:work)).to eq(@modified_work)
        end

        it " - work shouldn't be updated in database" do
          serialized_not_updated_work = serialize(Work.find(@loaded_work.id))
          serialized_loaded_work = serialize(@loaded_work)
          expect(serialized_not_updated_work).to eq(serialized_loaded_work)
        end
      end

      context " - JSON format" do
        before(:each) { put :update, params: { id: @loaded_work.public_uid, work: serialize(@modified_work) }, format: :json } #update need to have :id in :params
        it_behaves_like "unauthorized examples JSON" 

        it "- shouldn't returns a work." do
          response_body = parser(response.body)
          expect(response_body.keys).to eq([:notice])
        end

        it " - work shouldn't be updated in database" do
          not_updated_work = Work.find(@loaded_work.id)
          serialized_not_updated_work = serialize(not_updated_work)
          serialized_loaded_work = serialize(@loaded_work)

          expect(serialized_not_updated_work).to eq(serialized_loaded_work)
        end
      end
    end
  end

  describe " - POST #registration_update" do 
    before(:each) do
      @user = create(:user, :with_workmen_account, :with_works, works_count: 2)
      @work = build(:work)
    end
      
    context " - user signed in" do
      before(:each) {sign_in(@user)}

      context " - new work is created" do
        before(:each) { post :registration_update, params: { work: @work.attributes, existed_works_id: @user.work_ids } }

        it " - work should be added to user." do
          returned_work = assigns(:work)
          @user.reload

          expect(returned_work.users.count).to eq(1)
          expect(returned_work.users.first.id).to eq(@user.id)
          expect(@user.works.count).to eq(3)
        end
      end

      context " - new work is not created" do
        before(:each) { post :registration_update, params: { work: {title: ""}, existed_works_id: @user.work_ids } }

        it " - work shouldn't be added to user." do
          @user.reload

          expect(@user.works.count).to eq(2)
        end
      end

      context " - work is saved into database" do
        context " - HTML format" do
          before(:each) { post :registration_update, params: { work: @work.attributes, existed_works_id: @user.work_ids } }
    
          it_behaves_like "response status", 302
          it_behaves_like "notice", "Works have been set and new work has been created."
          it_behaves_like "redirect to", :root
    
          it " - should returns a new created work." do
            serialized_returned_work = serialize(assigns(:work))
            serialized_work = serialize(@work)
            serialized_work[:public_uid] = serialized_returned_work[:public_uid]

            expect(serialized_returned_work).to eq(serialized_work)
          end

          it " - created work should be saved into database" do
            serialized_work = serialize(@work)
            serialized_work[:public_uid] = assigns(:work).public_uid
            serialized_saved_work = serialize(Work.find(assigns(:work).id))

            expect(serialized_saved_work).to eq(serialized_work)
          end
        end
    
        context " - JSON format" do
          before(:each) { post :registration_update, format: :json, params: { work: @work.attributes, existed_works_id: @user.work_ids } }
          
          it_behaves_like "response status", 201
          
          it " - should return a notice" do
            response_body = parser(response.body)
            expect(response_body[:notice]).to eq("Works have been set and new work has been created.")
          end
          
          it " - should returns a new created work." do
            serialized_returned_work = parser(response.body)[:work].first
            serialized_work = serialize(@work)
            serialized_work[:id] = serialized_returned_work[:id]
            serialized_work[:public_uid] = serialized_returned_work[:public_uid]
    
            expect(serialized_returned_work <= serialized_work). to be true
          end
        end
      end
  
      context " - new work isn't saved into database" do
        before(:each) do     #this is reason why work will not be saved into database
          @work.title = ""
        end
  
        context " - HTML format" do
          before(:each) { post :registration_update, params: { work: @work.attributes, existed_works_id: @user.work_ids } }
           
          it_behaves_like "response status", 302
          it_behaves_like "notice", "Works have been set but new work has not been created."
          it_behaves_like "redirect to", :root
        end
  
        context " - JSON format" do
          before(:each) { post :registration_update, format: :json, params: { work: @work.attributes, existed_works_id: @user.work_ids } }
    
          it_behaves_like "response status", 201
  
          it " - should return a notice" do
            expect(parser(response.body)[:notice]).to eq("Works have been set but new work has not been created.")
          end
        end
      end 
    end

    context " - without signed in user" do
      context " - HTML format" do
        before(:each) { post :registration_update, params: { work: @work.attributes, existed_works_id: @user.work_ids } }
 
        it_behaves_like "unauthorized examples HTML"  
  
        it "- shouldn't returns a work." do
          expect(assigns(:work)).to eq(nil)
        end
      end
 
      context " - JSON format" do
        before(:each) { post :registration_update, format: :json, params: { work: @work.attributes, existed_works_id: @user.work_ids } }
 
        it_behaves_like "unauthorized examples JSON" 
 
        it "- shouldn't returns work." do
          response_body = parser(response.body)

          expect(response_body.keys).to eq([:notice])
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @work = create(:work)
    end

    context " - admin signed in" do
      before(:each) {sign_in_admin}

      context " - HTML format" do
        before(:each) {delete :destroy, params: { id: @work.public_uid }}

        it_behaves_like "response status", 302
        it_behaves_like "redirect to", 'work#index'
        it_behaves_like "notice", "Work has been destroyed."

        it " - should destroy a work from database" do
          expect{Work.find(@work.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context " - JSON format" do
        before(:each) {delete :destroy, format: :json, params: { id: @work.public_uid }}

        it_behaves_like "response status", 204

        it " - should destroy a work from database" do
          expect{Work.find(@work.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end

        it " - should return a notice" do
          response_body = parser(response.body)
          expect(response_body[:notice]).to eq("Work has been destroyed.")
        end
      end
    end

    context " - without signed in user" do
      context " - HTML format" do
        before(:each) {delete :destroy, params: { id: @work.public_uid }}

        it_behaves_like "unauthorized examples HTML"

        it " - work shouldn't be destroyed." do
          expect(Work.find(@work.id).blank?).to be false
        end
      end

      context " - JSON format" do
        before(:each) {delete :destroy, format: :json, params: { id: @work.public_uid }}

        it_behaves_like "unauthorized examples JSON"

        it " - work shouldn't be destroyed." do
          expect(Work.find(@work.id).blank?).to be false
        end
      end
    end
  end

  describe "- GET #show_work_users" do 
    let(:requested_work){ create(:work, :with_users, users_count: 5) }

    context " - HTML format" do
      before(:each) { get :show_work_users, params: {id: requested_work} }
      
      it_behaves_like "response status", 200
      it_behaves_like "render template", :show_work_users

      it "- should returns work users." do
        expect(assigns(:work_users).count).to eq(5)
      end
    end

    context " - JSON format" do
      before(:each) {get :show_work_users, format: :json, params: {id: requested_work} }
      let(:serialized_users) {parser(response.body)[:users]}

      it_behaves_like "response status", 200

      it "- should returns a work users." do
        expect(serialized_users.count).to eq(5)
      end
    end
  end
end
