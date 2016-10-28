include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.geo_ip
namespace erlang geo_ip

/**
* Идентификатор места по базе http://www.geonames.org/
**/
typedef i32 GeoID

const GeoID GEO_ID_UNKNOWN = -1

struct LocationInfo {
    // GeoID города
    1: required GeoID city_geo_id;
    // GeoID страны
    2: required GeoID country_geo_id;
    // Полное описание локации в json
    // подробное описание на сайте https://www.maxmind.com/en/geoip2-city
    3: required string raw_response;
}
// Информация о регоине
struct SubdivisionInfo{
        // глубина в иерархии. Чем ниже тем цифра выше. Например 1 - Московская область. 2 - Подольский район.
       1: required i16 level
       2: required string subdivision_name;
}

/**
* Информация о данном GeoID
**/
struct GeoIDInfo{
   1: required GeoID geoname_id;
   2: required string country_name;
   3: optional set<SubdivisionInfo> subdivisions;
   4: optional string city_name;
}

/**
* Интерфейс Geo Service для клиентов - "Columbus"
*/
service GeoIpService {
    /**
    * Возвращает информацию о предполагаемом местоположении по IP
    * если IP некоректный то кидается InvalidRequest с этим IP
    * если для IP не найдена страна или город то в LocationInfo, данное поле будет иметь значение GEO_ID_UNKNOWN
    **/
    LocationInfo GetLocation (1: domain.IPAddress ip) throws (1: base.InvalidRequest ex1)

    /**
    *  тоже что и GetLocation, но для списка IP адресов
    **/
    map <domain.IPAddress, LocationInfo> GetLocations (1: set <domain.IPAddress> ip) throws (1: base.InvalidRequest ex1)

    /**
    * Возвращает структуру с названием места на указанном языке
    * geo_ids - список geo-id по которым нужно получить информацию.
    * lang - язык ответа. Например: "RU", "ENG"
    *
    * если нет данных по какому-то geo-id - то в мапе в качестве ключа он будет, но значение будет null
    * если язык не поддерживается -> InvalidRequest
    **/
    map <GeoID, GeoIDInfo> GetLocationInfo (1: set<GeoID> geo_ids, 2: string lang) throws (1: base.InvalidRequest ex1)

     /**
     *  логика такая же как и в GetLocationInfo
     * Возвращает наименование географического объекта по указанному geoID.
     * При передаче geoID страны - название страны
     * При передаче geoID региона - название региона
     * При передаче geoID города - название города
     * и т.д.
     **/
     map <GeoID, string> GetLocationName (1: set<GeoID> geo_ids, 2: string lang) throws (1: base.InvalidRequest ex1)

}