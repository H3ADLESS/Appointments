package appointments

/**
 * Created by H3ADLESS on 08.01.2017.
 */
enum ArrangementType {

    USE_APP("USE_APP"),
    USE_MAIL("USE_MAIL"),
    USE_EXTERNAL_WEBSITE("USE_EXTERNAL_WEBSITE")

    String name

    public ArrangementType (String name){
        this.name = name
    }

}