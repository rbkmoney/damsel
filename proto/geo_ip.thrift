include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.geo_ip

/**
* Идентификатор места по базе http://www.geonames.org/
**/
typedef i32 GeoID

struct LocationInfo {
    // GeoID города
    1: required GeoID cityGeoID;
    // GeoID страны
    2: required GeoID countryGeoID;
    // Полное описание локации в json
    // подробное описание на сайте https://www.maxmind.com/en/geoip2-city
    3: required string rawResponse;
}
// Информация о регоине
struct SubdivisionInfo{
        // глубина в иерархии. Чем ниже тем цифра выше. Например 1 - Московская область. 2 - Подольский район.
       1: required i16 level
       2: optional string subdivisionName;
}

// Информация о данном GeoID
struct GeoIDInfo{
   1: required GeoID geonameId;
   2: string countryName;
   3: set<SubdivisionInfo> subdivisions;
   4: optional string cityName;
}


/** Исключение, сигнализирующее о том, что невозможно определить местоположение по одному из указанных IP */
exception CantDetermineLocation {}
/** Исключение, сигнализирующее о том, что в базе нет описания для одного из указанных GeoID */
exception LocationNotFound {
    1: list<GeoID> geoIDs
}

/**
* Интерфейс Geo Service для клиентов - "Columbus"
*/
service GeoIpService {
    /**
    * Возвращает информацию о предполагаемом местоположении по IP
    **/
    map <domain.IPAddress, LocationInfo> GetLocation(1: set<domain.IPAddress> ip) throws (1: CantDetermineLocation ex1)
    /**
     * Возвращает текстовое описание места на указанном языке
     * GeoIDs - список geo-id по которым нужно получить информацию.
     * lang - язык ответа. Например: "RU", "ENG"
     **/
    map <GeoID, GeoIDInfo> GetLocationInfo (1: set<GeoID> geoIDs, 2: string lang) throws (1: LocationNotFound ex1)
}