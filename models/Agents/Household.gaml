/**
* In: SahelFlux
* Name: Household
* Author: Arthur Scriban (arthur.scriban@cirad.fr)
* Tags: 
*/


model Household

import "../SpatialEntities/Parcel.gaml"
import "Household.gaml"
import "AnimalGroup.gaml"
import "ORPHeap.gaml"

global {
	
	int nbHousehold <- 10; // TODO Dummy
	int nbBushFieldsPerHh <- 10; // TODO Dummy
	int nbHomeFieldsPerHh <- 2; // TODO Dummy
	
	action instantiateHouseholds {
		write "Populating the village.";
		assert length (parcel where (each.homeField)) > nbHomeFieldsPerHh * nbHousehold; // Tests if enough home parcels are available
		create household number: nbHousehold {
			householdColour <- rnd_color(255);
			
			// Associating parcels
			ask nbHomeFieldsPerHh among (listAllHomeParcels where (each.myOwner = nil)) {
				self.myOwner <- myself;
				myOwner.myHomeParcelsList <+ self;
				self.parcelColour <- myself.householdColour / homeParcelsDimmingFactor;
			}
			ask nbBushFieldsPerHh among (listAllBushParcels where (each.myOwner = nil)) {
				self.myOwner <- myself;
				myOwner.myBushParcelsList <+ self;
				self.parcelColour <- myself.householdColour;
			}
						
			// Giving a mobile herd
			create mobileHerd with: [
				myHousehold::self,
				herdSize::round(meanHerdSize),
				herdColour::self.householdColour
			] {	
				myHousehold.myMobileHerd <- self;
				// Paddocking initialisation
				do resetSleepSpot;
				location <- currentSleepSpot.location;
			}
		}
		write "	Done. " + length(household) + " households, " + length(mobileHerd) + " mobile herds.";
	}
}

species household {
	rgb householdColour;
	// Links to other agents
	list<parcel> myBushParcelsList;
	list<parcel> myHomeParcelsList;
	mobileHerd myMobileHerd;
	fattenedAnimal myFattenedAnimals;
	float foragePile;
	ORPHeap myORPHeap;
	
}

