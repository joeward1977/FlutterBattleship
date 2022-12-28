class Location {
  // Static guess constants
  static const int UNGUESSED = 0;
  static const int HIT = 1;
  static const int MISSED = 2;

  int status;
  bool hasShip;

  // Location constructor.
  Location([this.status = UNGUESSED, this.hasShip = false]);

  // Was this Location a hit?
  bool checkHit() {
    return status == HIT;
  }

  // Was this location a miss?
  bool checkMiss() {
    return status == MISSED;
  }

  // Was this location unguessed?
  bool isUnguessed() {
    return status == UNGUESSED;
  }

  // Mark this location a hit.
  void markHit() {
    status = HIT;
  }

  // Mark this location a miss.
  void markMiss() {
    status = MISSED;
  }

  // Return whether or not this location has a ship.
  bool hasAShip() {
    return hasShip;
  }

  // Set the value of whether this location has a ship.
  void setShip(bool val) {
    hasShip = val;
  }

  // Set the status of this Location.
  void setStatus(int status) {
    this.status = status;
  }

  // Get the status of this Location.
  int getStatus() {
    return status;
  }

  @override
  String toString() {
    return "Status: $status, HasShip: $hasShip";
  }
}
