require 'spec_helper'

module Paranoic
  describe AttributePermission do
    describe "Accessible attributes" do
      it { expect(subject).to allow_mass_assignment_of(:class_name) }
      it { expect(subject).to allow_mass_assignment_of(:attribute_name) }
      it { expect(subject).to allow_mass_assignment_of(:bin) }
    end

    describe "Columns" do
      it { expect(subject).to have_db_column(:id) }
      it { expect(subject).to have_db_column(:class_name).of_type(:string) }
      it { expect(subject).to have_db_column(:attribute_name).of_type(:string) }
      it { expect(subject).to have_db_column(:bin).of_type(:integer) }
      it { expect(subject).to have_db_column(:created_at).of_type(:datetime).with_options(:null => false) }
      it { expect(subject).to have_db_column(:updated_at).of_type(:datetime).with_options(:null => false) }
    end
  end
end
