package appointments

/**
 * Created by H3ADLESS on 14.01.2017.
 */
enum LtiRole {

    LTI_ADMIN("LTI_ADMIN"),
    LTI_INSTRUCTOR("LTI_INSTRUCTOR"),
    LTI_TEACHING_ASSISTANT("LTI_TEACHING_ASSISTANT"),
    LTI_STUDENT("LTI_STUDENT")

    String name

    public LtiRole (String name){
        this.name = name
    }

}