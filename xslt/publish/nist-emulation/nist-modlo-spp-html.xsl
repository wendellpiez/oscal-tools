<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
    version="3.0">
    
    <!--
        
        1. Analysis of 'pull' - data sources for presentation
        2. Sample data / NIST-SSP-proto with NIST-compliant text and boilerplate
        3. Rules for validation of such an SSP against NIST requirements
    
    -->
    
    <!-- prone to breakage until this is stabilized -->
    <!--<xsl:import href="../../usnistgov/OSCAL/src/utils/util/publish/XSLT/oscal_control-common_html.xsl"/>-->
    
    <xsl:template match="/" expand-text="true">
        <html>
            <head>
                <title>{ /descendant::title[1]/normalize-space(.) }</title>
                <xsl:call-template name="css"/>
            </head>
            <body>
                <xsl:call-template name="section1"/>
                <xsl:call-template name="section2"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template name="yesno-button">
        <form class="yesnobutton">
            <input type="radio" name="yesno" value="yes"/>Yes
            <input type="radio" name="yesno"  value="no"/>No
        </form>
    </xsl:template>
    
    <xsl:template name="modlo-button">
        <form class="modlo-button">
            <input type="radio" name="impact" value="LOW" />LOW
            <input type="radio" name="impact" value="MODERATE"/>MODERATE
        </form>
    </xsl:template>

    <xsl:template name="section1">
        <section>
            <h1 class="underline">1. SYSTEM IDENTIFICATION</h1>
            <xsl:call-template name="section1-1"/>
            <xsl:call-template name="section1-2"/>
            <xsl:call-template name="section1-3"/>
            <xsl:call-template name="section1-4"/>
            <xsl:call-template name="section1-5"/>
            <xsl:call-template name="section1-6"/>
            <xsl:call-template name="section1-7"/>
            <xsl:call-template name="section1-8"/>
        </section>
    </xsl:template>
    
    <xsl:template name="section1-1">
        <section>
            <h2><span class="num">1.1.</span> System Name/Title: <span class="instruct">State the
                    name of the system. Spell out acronyms.</span></h2>
            <xsl:for-each select="/*/system-characteristics/system-name">
                <p class="response">
                    <xsl:apply-templates/>
                </p>
            </xsl:for-each>
            <section>
                <h3><span class="num">1.1.1.</span> System Categorization (FIPS 199 overall System
                    impact) – <span class="instruct">Low / Moderate</span> Impact</h3>
                <xsl:for-each select="/*/system-characteristics/security-sensitivity-level">
                    <!-- should be 'moderate' or 'high'                   -->
                    <p class="response">
                        <xsl:value-of select="o:title-case(.)"/>
                    </p>
                </xsl:for-each>
                
            </section>
            <section>
                <h3><span class="num">1.1.2.</span> System Unique Identifier: <span class="instruct"
                        >Insert the System Unique Identifier (Plan ID)</span></h3>
                <p>Note<b>: </b>The System UID consists of five numeric characters (xxx-xx) assigned
                    by the Information Technology Security and Networking Division. The first three
                    characters will correspond to the System Owner OU/Division.</p>
                <xsl:for-each select="/*/system-characteristics/system-id[@identifier-type='http://nist.gov/ns/ssp']">
                    <!-- should be 'moderate' or 'high'                   -->
                    <p class="{ if (matches(.,'^\d\d\d-\d\d$')) then 'response' else 'response bad'}">
                        <xsl:value-of select="normalize-space(.)"/>
                    </p>
                </xsl:for-each>
            </section>
        </section>
    </xsl:template>
    
    <xsl:variable name="expected-roles" xmlns="http://csrc.nist.gov/ns/oscal/1.0">
        <!-- The lookup table follows the form of the SSP rendition -->
        <role>Responsible Organization</role>
        <contacts>
            <role>Authorizing Official (Designated Approving Authority)</role>
            <role>Co-Authorizing Official (for non- Office of Information Systems Management (OISM)
                systems)</role>
            <role>NIST Operating Unit IT Security Officer</role>
            <role>System Owner</role>
            <role>Primary Information Contact</role>
            <role>Secondary Information Contact</role>
        </contacts>
        <role>Information System Security Officer (ISSO) (assignment of security responsibility)</role>
    </xsl:variable>
    
    
    <xsl:template name="section1-2">
        <section>
            <h2><span class="num">1.2.</span> Responsible Organization:</h2>
            <xsl:apply-templates select="$expected-roles/role[1]" mode="contact-table"/>
            <section>
                <h3><span class="num">1.2.1.</span> Information Contacts:</h3>
                <xsl:apply-templates select="$expected-roles/contacts/role" mode="contact-section"/>
                
            <!--    <section>
                    <h4><span class="num">1.2.1.1.</span> Authorizing Official (Designated Approving
                        Authority):</h4>
                    <table>
                        <tr>
                            <td>
                                <p>Name:</p>
                            </td>
                            <td>
                                <p>Delwin Brockett</p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Title:</p>
                            </td>
                            <td>
                                <p>NIST Chief Information Officer</p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Office Address:</p>
                            </td>
                            <td>
                                <p>100 Bureau Drive, Mail Stop 1800, 20899</p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Work Phone:</p>
                            </td>
                            <td>
                                <p>301-975-6500</p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p>e-Mail Address:</p>
                            </td>
                            <td>
                                <p class="c0000FF underline">Delwin.brockett@nist.gov</p>
                            </td>
                        </tr>
                    </table>
                </section>
                <section>
                    <h4><span class="num">1.2.1.2.</span> Co-Authorizing Official (for non- Office
                        of Information Systems Management (OISM) systems):</h4>
                    <table>
                        <tr>
                            <td>
                                <p>Name:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Title:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Office Address:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Work Phone:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>e-Mail Address:</p>
                            </td>
                            <td> </td>
                        </tr>
                    </table>
                </section>
                <section>
                    <h4><span class="num">1.2.1.3.</span> NIST Operating Unit IT Security
                        Officer:</h4>
                    <table>
                        <tr>
                            <td>
                                <p>Name:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Title:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Office Address:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Work Phone:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>e-Mail Address:</p>
                            </td>
                            <td> </td>
                        </tr>
                    </table>



                </section>
                <section>
                    <h4><span class="num">1.2.1.4.</span> System Owner:</h4>
                    <table>
                        <tr>
                            <td>
                                <p>Name:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Title:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Office Address:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Work Phone:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>e-Mail Address:</p>
                            </td>
                            <td> </td>
                        </tr>
                    </table>
                </section>
                <section>
                    <h4><span class="num">1.2.1.5.</span> Primary Information Contact:</h4>
                    <table>
                        <tr>
                            <td>
                                <p>Name:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Title:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Office Address:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Work Phone:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>e-Mail Address:</p>
                            </td>
                            <td> </td>
                        </tr>
                    </table>
                </section>
                <section>
                    <h4><span class="num">1.2.1.6.</span> Secondary Information Contact:</h4>
                    <table>
                        <tr>
                            <td>
                                <p>Name:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Title:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Office Address:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>Work Phone:</p>
                            </td>
                            <td> </td>
                        </tr>
                        <tr>
                            <td>
                                <p>e-Mail Address:</p>
                            </td>
                            <td> </td>
                        </tr>
                    </table>
                </section>
            -->
            </section>
            <section>
                <h3><span class="num">1.2.2.</span> Information System Security Officer (ISSO)
                    (assignment of security responsibility):</h3>
                <xsl:apply-templates select="$expected-roles/role[last()]" mode="contact-table"/>
            </section>
        </section>
    </xsl:template>
    
<!-- template matches not a role in the document, but from the XSLT lookup 
    $expected-roles -->
    
    <xsl:key name="role-by-title" match="metadata/role" use="title"/>
    
    <xsl:key name="responsibility" match="metadata/responsible-party" use="@role-id"/>
    
    <xsl:key name="party-by-id" match="metadata/party" use="@id"/>
    
    <xsl:variable name="ssp" select="/"/>
    
    <!-- Matching a role in $roles -->
    <xsl:template match="role" mode="contact-table">
        <xsl:variable name="assignment" select="key('role-by-title',string(.),$ssp)/key('responsibility',@id)/key('party-by-id',party-id)/(person | org)"/>
        <xsl:for-each select="$assignment">
            <table>
                <xsl:apply-templates mode="#current" select="person-name, org-name, prop[@name='title'], address, phone, email, url"/>
                <!-- XXX any other fields? possible short-name, person-id, org-id, other props, annotations, links -->
            </table>
            <xsl:apply-templates select="remarks"/>
        </xsl:for-each>
        <xsl:if test="empty($assignment)">
            <h5 class="bad" xsl:expand-text="true">No assignment found for role '{ . }'</h5>
        </xsl:if>
    </xsl:template>
    
    <xsl:template mode="contact-label" match="person-name">Name:</xsl:template>
    <xsl:template mode="contact-label" match="org-name">Organization name:</xsl:template>
    <xsl:template mode="contact-label" match="prop[@name='title']">Title:</xsl:template>
    <xsl:template mode="contact-label" match="address">Office address:</xsl:template>
    <xsl:template mode="contact-label" match="phone">Telephone:</xsl:template>
    <xsl:template mode="contact-label" match="email">Email:</xsl:template>
    <xsl:template mode="contact-label" match="url">Web site:</xsl:template>
    
    <!-- Matching party in the SSP -->
    
    <xsl:template match="party/*/*" mode="contact-table">
        <tr>
            <th class="right-align">
                <xsl:apply-templates select="." mode="contact-label"/>
            </th>
            <td>
                <xsl:apply-templates/>
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template match="address/*">
        <xsl:if test="exists(preceding-sibling::*)"><br class="br"/></xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Matching contacts/role inside $roles -->
    <xsl:template match="contacts/role" mode="contact-section">
        <section>
            <h4><span class="num" xsl:expand-text="true">1.2.1.{ count(.|preceding-sibling::*) }.</span>
                <xsl:apply-templates/>
            </h4>
            <xsl:apply-templates select="." mode="contact-table"/>
        </section>
    </xsl:template>
    
    <xsl:template match="remarks">
        <div class="remarks response">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
        
    <xsl:template name="section1-3">
        <section>
            <h2><span class="num">1.3.</span> System Operational Status:</h2>
            <p><input type="checkbox"/> Operational <input type="checkbox"/> Under Development
                    <input type="checkbox"/> Major Modification <input type="checkbox"/> Retired</p>
            <p>If the system is under development or undergoing a major modification, include a
                schedule for the system design, development, implementation, and operational
                phases.</p>

        </section>
    </xsl:template>
    
    <xsl:template name="section1-4">
        <section>
            <h2><span class="num">1.4.</span> General Description/Purpose of System:</h2>
            <section>
                <p><span class="num">a)</span> What is the function/purpose of the system? <span
                        class="instruct">Provide a short, high-level description of the
                        function/purpose of the system.</span></p>
            </section>
            <section>
                <p><span class="num">b)</span> User Population served (i.e. all of NIST, all or part
                    of a given OU, all or part of a given division within an OU, internal
                    researchers, external researchers, administrative officers, the general public,
                        etc.)<b>: </b><span class="instruct">In the table below list user types and
                        state whether they are internal or external to the system owner's agency.
                        Add rows </span><span class="instruct">to define different user
                        populations</span><span class="instruct"> as needed.</span></p>
                <!-- /*/system-implementation/user -->
                <!-- XXX general characterization of user population? -->
                <p class="bold">User Population(s) Served:</p>
                <table>
                    <tr>
                        <th>
                            <p class="bold">User Population Served</p>
                        </th>
                        <th>
                            <p class="bold">Internal or External?</p>
                        </th>
                    </tr>
                    <tr>
                        <td> </td>
                        <td> </td>
                    </tr>
                </table>
            </section>
            <section>
                <p><span class="num">c)</span> Number of end users and privileged users:<b
                        > </b><span class="instruct">In the table below, provide the <i
                            class="underline">approximate</i> number of users and administrators of
                        the system</span><b>. </b><span class="instruct">Include all those with
                        privileged access such as system administrators, database administrators,
                        application administrators, etc. Add rows to define different roles
                        </span><span class="instruct">as needed</span><span class="instruct"
                        >.</span></p>

                <p class="bold">Roles of Users and Number of Each Type:</p>
                <table>
                    <tr>
                        <th>
                            <p class="bold">Number of Users</p>
                            <!-- XXX an annotation? -->
                        </th>
                        <td>
                            <p class="bold">Number of Administrators/</p>
                            <p class="bold">Privileged Users</p>
                        </td>
                    </tr>
                    <tr>
                        <td> </td>
                        <td> </td>
                    </tr>
                </table>
            </section>
            <section>
                <p><span class="num">d)</span> How does the system fulfill NIST mission
                    requirements? <span class="instruct">Provide narrative description of how system
                        fulfills NIST mission.</span>
                    <!-- XXX ? --></p>
            </section>
            <section>
                <p><span class="num">e)</span> Exhibit 53/300 Account Code<b>: </b><span
                        class="instruct">Provide system specific accounting code</span></p>

                <p>
                    <span class="instruct">NOTE: Delete this entire note when “e” has been
                        addressed.</span>
                </p>
                <p class="instruct bold">For most Laboratory Systems the Exhibit 53 # is
                    006-55-01-26-02-7021-00;</p>
                <p>
                    <span class="instruct">For all others, check the Security Assessment and
                        Authorization Status spreadsheet, “SysDesc” tab, Column H</span>
                    <b>.]</b>
                </p>
            </section>

        </section>
    </xsl:template>
    
    <xsl:template name="section1-5">
        <!-- /*/system-characteristics -->
        <section>
            <h2><span class="num">1.5.</span> System Environment:</h2>
            <p><span class="instruct">Mark all that apply</span> (See NIST SP 800-18 for more
                information on this classification)<b>]</b></p>
            <p><b><input type="checkbox"/></b><b> Standalone or Small Office/Home Office (SOHO)
                </b>(encompasses a variety of small-scale environments and devices, ranging from
                laptops, mobile devices, or home computers, to telecommuting systems)</p>
            <p><b><input type="checkbox"/></b><b> Managed/Enterprise </b>(systems with defined,
                organized suites of hardware and software configurations, usually consisting of
                centrally-managed workstations and servers protected from the Internet by firewalls
                and other network security devices)</p>
            <p><b><input type="checkbox"/></b><b> Custom - Specialized Security-Limited
                    Functionality </b>(environment contains systems and networks at high risk of
                attack or data exposure, with security taking precedence over functionality)</p>
            <p><b><input type="checkbox"/></b><b> Custom – Legacy </b>(older machines or
                applications that may use older, less-secure communication mechanisms)</p>
            <p><b><input type="checkbox"/> Cloud – </b>Systems using access to a shared pool of
                configurable computing resources (e.g., networks, servers, storage, applications,
                and services) provided by a third party (outside NIST.)</p>
            <section>
                <p><span class="num">a)</span> Include a <u>detailed </u>topology narrative and graphic that clearly depicts
                    the system boundaries, system interconnections, and KEY devices within it.
                        (Note<b>: </b><i>this does not require depicting every workstation or
                        desktop</i>, but you must include an instance for each operating system in
                    use, an instance for portable components (if applicable), <b><u>all</u>
                        <u>servers</u></b>, (file, print, web, database, application, etc.) as well
                    as any networked workstations, (e.g., Unix, Windows, Mac, Linux Desktops)
                    firewalls, routers, switches, copiers, printers, lab equipment, handhelds, etc.)
                    If components of other systems that interconnect/interface with this system need
                    to be shown on the diagram, denote system boundaries by referencing the security
                    plan number of other system(s) in the diagram.</p>

                <p class="bold">The system graphic is included within this Security Assessment and
                    Authorization (A&amp;A) package.</p>

                <p>
                    <span class="instruct">Provide a narrative in this section that clearly lists
                        and describes each system component (group of like-configured assets or
                        applications), along with their Confidentiality, Integrity, and Availability
                        (CIA) ratings. Connections among components, as well as to assets outside
                        this system boundary should be described in detail.</span>
                </p>
            </section>
            <section>
                <p><span class="num">b)</span> Include or reference a <b class="underline">complete and accurate</b> listing
                    of all hardware (a reference to the NIST IT asset inventory system and/or
                    Managed Desktop asset inventory is acceptable) and software (system software and
                    application software) components, including make/OEM, model, version, and
                    service packs.</p>
                <p class="bold">The system asset inventory is included within the Security
                    Assessment and Authorization (A&amp;A) package.</p>

                <p>
                    <span class="instruct">If the system being documented is an application and
                        therefore does not have an asset inventory, so state and remove the
                        reference.</span>
                </p>
            </section>
            <section>
                <p><span class="num">c)</span> Software category for <b class="underline">all types</b> of software installed
                    within the boundaries of this system must be documented. List all applications
                    supported by the general support system.</p>
                <p class="bold">This information is provided in the system software inventory
                    included within this Security Assessment and Authorization package</p>
            </section>
            <section>
                <p><span class="num">d)</span> Hardware and Software Ownership - Is all hardware and software government
                        owned?<span class="instruct">Yes/No</span></p>
                <xsl:call-template name="yesno-button"/>
                <p>If no, explain:</p>
            </section>
            <section>
                <p><span class="num">e)</span> General Location of System Components (see the asset inventory for specific
                    component buildings/rooms) – <span class="instruct">In the table below, indicate
                        the location(s) of system components. If all components are located within
                        NIST facilities, note “All” within the “NIST Facility Column.” If all
                        components are located at a contractor facility, note “All” within the
                        “Contractor Facility” column. For systems with components that reside at
                        both NIST and contractor facilities, list the system components that reside
                        within each facility in the appropriate column (i.e., components that reside
                        within NIST facilities should be listed in the “NIST Facility” column and
                        components that reside in contractor facility should be listed within the
                        “Contractor Facility” column). Document an estimate of the number of hosts
                        that are located in user residences and the number of laptops used for
                        travel in 'Other'.</span></p>
                <p class="bold">Location of System Components</p>
                <table>
                    <tr>
                        <th>
                            <p class="bold">NIST Facility</p>
                        </th>
                        <th>
                            <p class="bold">Contractor Facility</p>
                        </th>
                        <th>
                            <p class="bold">Other (explain)</p>
                        </th>
                    </tr>
                    <tr>
                        <td> </td>
                        <td> </td>
                        <td>
                            <p>Number of hosts located in user residences:</p>

                            <p>Number of laptops used for travel:</p>
                        </td>
                    </tr>
                </table>

                <p><span class="num">f)</span> System Support – <span class="instruct">In the table below, indicate whether
                        the system is supported/maintained by government or contract staff (or
                        both). If all components are government supported, noted “All” within the
                        “Government Supported” column. If all components are contract staff
                        supported, indicate “All” within the contract staff supported column. For
                        systems where there is a mix of government staff and contractor staff
                        management, list the system components within the appropriate column (e.g.,
                        components that are managed by government staff should be listed in the
                        “Government Staff Supported” column and components that are managed by
                        contractor staff should be listed within the “Contractor Staff Supported”
                        column).</span></p>
                <table>
                    <tr>
                        <th>
                            <p class="bold">Government Supported</p>
                        </th>
                        <th>
                            <p class="bold">Contract Staff Supported</p>
                        </th>
                    </tr>
                    <tr>
                        <td> </td>
                        <td> </td>
                    </tr>
                </table>

                <p><span class="num">g)</span> Detail any environmental or technical factors that raise special security
                    concerns, such as use of Personal Digital Assistants, wireless technology,
                    externally hosted data, Software as a Service, and Cloud Computing, etc. <span
                        class="instruct">If applicable, provide narrative. If none, so
                    state.</span></p>
            </section>
        </section>
    </xsl:template>
    
    <xsl:template name="section1-6">
        <!-- /*/system-implementation interconnections ? -->
        <section>
            <h2><span class="num">1.6.</span> System Interconnections/Information Sharing:</h2>
            <p>NOTE<b>: </b>NIST SP 800-18 defines a system interconnection as a “<b>direct</b>
                connection of two or more IT systems for the purpose of sharing information
                resources.”</p>
<section>
            <p>a) A <u>detailed</u> discussion of system connectivity -- where data goes out and
                who/what is authorized to come in, name(s) of interconnected system(s), type of
                interconnection(s), sensitivity levels of the interconnected system(s), and any
                security concerns and rules of behavior of the other system(s) that need to be
                considered in the protection of this system. Include a discussion of ALL connections
                to other systems not governed by this security plan, including untrusted connections
                or connections to the Internet that require protective devices as a barrier to
                unauthorized system intrusion.</p>

            <p>
                <b>All system connectivity is via TCP/IP across the NIST Network Infrastructure (SSP
                    181-04). The NIST Network Infrastructure system provides all services for
                    physical cabling, network frame synchronization/flow control/error checking,
                    routing, switching, and DNS. </b>
                <span class="instruct">Revise or delete this pre-filled statement if it does not
                    apply as written to the system being documented</span>
                <b>. </b>
                <span class="instruct">If the statement does apply, delete this bracketed
                    statement.</span>
            </p>

            <p>
                <b>Remote connections to NIST internal resources (i.e. telecommuting, travel, etc.)
                    are made via SSL Remote Access services managed as part of the NIST Network
                    Security system (SSP 181-01). </b>
                <span class="instruct">Revise or delete this pre-filled statement if it does not
                    apply as written to the system being documented</span>
                <b>. </b>
                <span class="instruct">If the statement does apply, delete this bracketed
                    statement.</span>
            </p>
</section><section>
            <p>b) In the table below, list system connections and check the appropriate box as to
                whether each connection is/are government-to-government (G2G),
                government-to-business (G2B), or government-to-citizen (G2C). Describe the controls
                to allow <u>and</u> restrict public access. <span class="instruct">Revise or add to
                    information in the table below if the pre-filled information does not apply to
                    the system being documented.</span></p>
            <table>
                <tr>
                    <th>
                        <p class="bold">Connection</p>
                        <p class="bold">(Sys ID # if NIST system or description if external)</p>
                    </th>
                    <th>
                        <p class="bold">G2G</p>
                    </th>
                    <th>
                        <p class="bold">G2B</p>
                    </th>
                    <th>
                        <p class="bold">G2C</p>
                    </th>
                    <th>
                        <p class="bold">Is the Connection Trusted?</p>
                    </th>
                </tr>
                <tr>
                    <td>
                        <p>181-01</p>
                    </td>
                    <td>
                        <p>√</p>
                    </td>
                    <td> </td>
                    <td> </td>
                    <td>
                        <p>Yes</p>
                        <xsl:call-template name="yesno-button"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p>181-04</p>
                    </td>
                    <td>
                        <p>√</p>
                    </td>
                    <td> </td>
                    <td> </td>
                    <td>
                        <p>Yes</p>
                        <xsl:call-template name="yesno-button"/>
                    </td>
                </tr>
            </table>

            <p>If the system includes trusted connections (e.g. connections that do not require
                barrier protection devices such as firewalls), discuss why the connection is
                trusted.</p>
            <p>
                <b>The NIST Network Infrastructure system (SSP 181-04) and the NIST Network Security
                    system (SSP 181-01) are trusted connections because they are operated by NIST
                    and are fully authorized to operate by the NIST CIO. </b>
                <span class="instruct">Revise this pre-filled comment/describe other trusted
                    connections if it does not apply to the system being documented.</span>
            </p>
</section><section>
            <p>c) Reference here and attach a full copy of all Interconnection Security Agreements
                (ISA) and Memoranda of Understanding (MOU)/Memoranda of Agreement (MOA) for
                provision of IT security for this connectivity. Other relevant NIST security plans
                may also be referenced. <u>Note: NIST SP 800-18 does NOT require an ISA/MOU/A with
                    owners of internal agency systems (i.e. internal to NIST).</u></p>
            <p>
                <span class="instruct">Reference ISAs, MOUs, MOAs. If none are required because the
                    only interconnections are with other NIST systems so state and delete the
                    remaining text under 1.5c.</span>
            </p>

            <p>
                <span class="instruct">If external connections exist, provide the following
                    information for <u>each</u> interconnection or the associated ISA/MOU/MOA may be
                    included within this Security Assessment and Authorization package if all of the
                    information below is provided.</span>
            </p>

            <p>Name of interconnected system:</p>
            <p>Organization of interconnected system:</p>
            <p>Type of interconnection (TCP/IP, T1, Dial-up, etc.):</p>
            <p>Authorizations for interconnection (MOU/A, ISA):</p>
            <p>Name and title of authorizing management official of the interconnected system:</p>
            <p>Date of authorization:</p>
            <p>FIPS 199 impact level of the interconnected system:</p>
            <p>Security<b> </b>Assessment and Authorization status of the interconnected system:</p>

        </section>
        </section>
    </xsl:template>
    
    <xsl:template name="section1-7">
        <section>
            <h2><span class="num">1.7.</span> Applicable Laws, Policies, and Regulations Affecting
                the System:</h2>
            <p>The system is subject to the DOC IT Security Program Policy and Minimum
                Implementation Standards along with the IT security laws and federal regulations
                including:</p>
            <p class="indented three">
                <span class="c0000FF underline">Public Law 107-347 E-Government Act of 2002</span>
                <span class="c0000FF underline"> (FISMA included)</span>
            </p>
            <p class="c0000FF indented three underline">Public Law 200-253 Computer Security Action
                of 1987</p>
            <p class="c0000FF indented three underline">OMB Circular No. A-130, Appendix III,
                Security of Automated Information Resources</p>
            <p class="c0000FF indented three underline">Federal Information Processing Standard
                (FIPS) 140-2, Security Requirements for Cryptographic Modules</p>
            <p class="c0000FF indented three underline">FIPS 199, Standards for Security
                Categorization of Federal Information and Information Systems</p>
            <p class="c0000FF indented three underline">FIPS 200, Minimum Security Requirements for
                Federal Information and Information Systems</p>
            <p class="indented three"><span class="c0000FF underline">Department of Commerce
                    Administrative Orders</span> and Security Policies</p>
            <p class="c0000FF indented three underline">Department of Commerce, Information
                Technology Security Program Policy (ITSPP)</p>
            <p class="c0000FF indented three underline">Department of Commerce, Interim Technical
                Requirements (CITRs)</p>
            <p class="indented three">
                <span class="c0000FF underline">NIST IT Security Policies (</span>
                <span class="c0000FF underline">http://inet.nist.gov/oism/iss_requirements.cfm</span>
                <span class="c0000FF underline">)</span>
            </p>
            <p class="c0000FF indented three underline">NIST Special Publication (SP) 80053 Rev. 4,
                Security and Privacy Controls for Federal Information Systems and Organizations</p>
            <p class="c0000FF indented three underline">NIST SP 80053A, Guide for Assessing the
                Security Controls in Federal Information Systems</p>
            <p class="c0000FF indented three underline">NIST SP 800-27, Engineering Principles for
                Information Technology Security (A Baseline for Achieving Security)</p>
            <p class="c0000FF indented three underline">NIST SP 800-37, Guide for the Security
                Certification and Accreditation of Federal Information Systems</p>
            <p class="c0000FF indented three underline">NIST SP 800-60, Guide for Mapping Types of
                Information and Information Systems to Security Categories: Volume 1 - Guide, Volume
                2 – Appendices</p>
            <p class="c0000FF indented three underline">NIST SP 800-64, Security Considerations in
                the System Development Life Cycle</p>
            <p class="indented three">NIST SP 800-97, Establishing Wireless Robust Security
                Networks: A Guide to IEEE</p>
            <p class="indented three">NIST S 6102.17 IT User Account Management Policy</p>

            <p>Do any additional laws or regulations apply specifically to this system? <span
                    class="instruct">Yes/No</span></p>
            <xsl:call-template name="yesno-button"/>
            <p>If yes, list them here:</p>

            <p>Privacy Act – <b>See NIST Privacy Controls; Privacy Impact and Risk Assessment
                    (AR-2).</b></p>
        </section>
    </xsl:template>
    
    <xsl:template name="section1-8">
        <!-- Information (data) types and impact levels for C/I/A -->
        <section>
            <h2><span class="num">1.8</span> General Description of Information and System
                Sensitivity/Impact:</h2>
            <p>FIPS 199 and NIST SP 800-60 Rev. 1 were used to determine all system impact
                levels.</p>
            <p>a) All 800-60 information/data types processed on the system (such as D.20.1 -
                Research and Development Information, or C.2.8.9 - Personal Identity and
                Authentication Information) must be determined and documented.</p>
            <p>The impact designation of the system or the application is a reflection of the data
                types that are resident on the system or managed by the application. </p>
            <p>
                <span class="instruct">Revise the listed data types and adjust impact levels as
                    appropriate for your system.</span>
            </p>

            <p>C.2.3.1 - Budget Formulation Information (L/L/L)</p>
            <p>C.2.3.2 - Capital Planning Information (L/L/L)</p>
            <p>C.2.3.3 - Enterprise Architecture Information (L/L/L)</p>
            <p>C.2.3.4 - Strategic Planning Information (L/L/L)</p>
            <p>C.2.3.5 - Budget Execution Information (L/L/L)</p>
            <p>C.2.4.1 - Contingency Planning Information (M/M/M)</p>
            <p>C.2.5.2 - User Fee Collection Information (L/L/M)</p>
            <p>C.2.5.3 - Federal Asset Sales Information (L/M/L)</p>
            <p>C.2.6.1 - Customer Services Information (L/L/L)</p>
            <p>C.2.6.4 - Public Relations Information (L/L/L)</p>
            <p>C.2.8.9 - Personal Identity and Authentication Information (M/M*/M)</p>
            <p>C.3.1.1 - Facilities, Fleet, and Equipment Management Information (L/L/L)</p>
            <p>C.3.1.2 - Help Desk Services Information (L/L/L)</p>
            <p>C.3.1.3 - Security Management Information (Physical) (M/M/L)</p>
            <p>C.3.1.4 - Travel Information (L/L/L)</p>
            <p>C.3.2.2 - Reporting and Information (Financial) (L/M/L)</p>
            <p>C.3.2.3 - Funds Control Information (M/M/L)</p>
            <p>C.3.2.4 - Accounting Information (L/M/L)</p>
            <p>C.3.2.5 - Payments Information (L/M/L)</p>
            <p>C.3.2.6 - Collections and Receivables Information (L/M/L)</p>
            <p>C.3.3.2 - Staff Acquisition Information (L/L/L)</p>
            <p>C.3.3.3 - Organization &amp; Position Management Information (L/L/L)</p>
            <p>C.3.3.5 - Benefits Management Information (L/M/L)</p>
            <p>C.3.3.10 - Human Resources Development Information (L/L/L)</p>
            <p>C.3.4.2 - Inventory Control Information (procured assets and resources) (L/L/L)</p>
            <p>C.3.4.4 - Services Acquisition Information (L/L/L)</p>
            <p>C.3.5.1 - System Development Information (L/M/L)</p>
            <p>C.3.5.2 - Lifecycle/Change Management Information (L/M/L)</p>
            <p>C.3.5.3 - System Maintenance Information (In-House applications) (L/M/L)</p>
            <p>C.3.5.4 - IT Infrastructure Maintenance Information (L/L/L)</p>
            <p>C.3.5.5 - IT Security Information (L/M/L)</p>
            <p>C.3.5.7 - Information Management Information (Privacy Act and Proprietary)
                (L**/M/L)</p>
            <p>C.3.5.8 - System and Network Monitoring Information (M/M/L)</p>
            <p>D.9.1 - Business and Industry Development Information (L/L/L)</p>
            <p>D.9.2 - Intellectual Property Protection Information (L/L/L) (C=M for trade
                secrets)</p>
            <p>D.19.1 - Scientific and Technical Research and Innovation Information (L/M***/L)</p>
            <p>D.20.1 - Research and Development Information (L/M***/L)</p>
            <p>D.20.2 - General Purpose Data and Statistics Information (L/L/L)</p>
            <p>D.20.3 - Advising and Consulting Information (L/L/L)</p>
            <p>D.20.4 - Knowledge Dissemination Information (L/L/L)</p>
            <p>D.21.2 - Standards Setting/Reporting Guideline Development Information (L/L/L)</p>
            <p>D.23.1 - Federal Grants (Non-State) Information (L/L/L)</p>
            <p>D.25.2 - Project/Competitive Grants Information (L/L/L)</p>

            <p>
                <span class="instruct">Revise or remove the following adjustments to impact levels
                    as appropriate for your system</span>
                <b>.]</b>
            </p>

            <p>*According to NIST SP 800-60 volume 2 Rev. 1, the integrity impact for this data type
                may be noted as low when it is at the OU or Division level and/or when the data is
                limited to federal employees and is for identification of these federal employees
                only.</p>
            <p>** According to the DOC ITSPP: Data that is subject to the Privacy Act of 1974 (and
                is therefore documented in the PIA) or is considered proprietary to a corporation or
                other organization should be assigned a moderate confidentiality impact level. The
                overall confidentiality impact for data types should follow the highest
                confidentiality impact of other data types processed by/stored within the
                application or system.</p>
            <p>**<u>*When intended for publication, these data types have been determined by the
                    NIST Director and Senior Management Advisory Board to be LOW for integrity</u>.
                When applicable, use the following standard text in 1b to justify the lowering of
                the integrity impact from the 800-60 provisional impact rating (moderate to
                low):</p>
            <p>“Since the research data is intended for general publication the overall impact of
                the research is low, the unauthorized modification of the data would have a limited
                adverse effect on NIST operations, assets, and individuals. Therefore the System
                Owner has determined that the integrity impact for information type [D.19.1/D.20.1]
                is LOW."</p>

            <p class="bordered centered"><b>Confidentiality, Integrity, and Availability Value
                    Guideline </b>(based on FIPS 199)</p>
            <table>
                <tr>
                    <th>
                        <p class="bold">Impact Level</p>
                    </th>
                    <th>
                        <p class="bold">Level Definition</p>
                    </th>
                </tr>
                <tr>
                    <td>
                        <p>High</p>
                    </td>
                    <td>
                        <p>Severe or catastrophic adverse effect on organizational operations,
                            organizational assets, or individuals such as loss of life, e.g. due to
                            faulty research or faulty calibrations.</p>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p>Moderate</p>
                    </td>
                    <td>
                        <p>Serious adverse effect on organizational operations, organizational
                            assets, or individuals such as loss of reputation or customer trust,
                            loss of external funding, loss of confidence in data, loss of critical
                            equipment.</p>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p>Low</p>
                    </td>
                    <td>
                        <p>Limited adverse effect on organizational operations, organizational
                            assets, or individuals such as inconvenience or loss of equipment.</p>
                    </td>
                </tr>
            </table>

            <p>
                <span class="instruct">If impact levels for information types processed by/stored
                    within the system differ from the 800-60 provisional impact levels for a given
                    data type or types, specify the disputed data type(s) and provide a
                    justification here. If there are no deviations from 800-60 provisional impact
                    levels, so state.</span>
            </p>

            <p>b) What would the risk of harm be (how would the NIST mission be affected) if the
                Confidentiality, Integrity, or Availability of the information processed was
                compromised?</p>
            <p>
                <span class="instruct">Detail impact to the NIST mission for all three security
                    objectives (C, I, and A). Describe what functions the system or application
                    supports and the adverse impact to NIST in the case of unauthorized release of
                    data, modification of the data and/or unavailability of data.</span>
            </p>

            <p>c) <span class="instruct">State the system’s overall sensitivity to compromise of
                    Confidentiality, Integrity, and Availability by providing a high, moderate, or
                    low rating, and detail the basis for that rating in the table below. Use FIPS
                    199 (</span><span class="c0000FF underline"
                        ><b>http://csrc.nist.gov/publications/fips/fips199/FIPS-PUB-199-final.pdf</b></span><span
                    class="instruct">) and/or the table in a) above as guidance.</span></p>
            <table>
                <tr>
                    <th>
                        <p class="bold">Security Objective</p>
                    </th>
                    <th>
                        <p class="bold">Impact Rating</p>
                    </th>
                    <th>
                        <p class="bold">Short Description of Basis for Rating</p>
                    </th>
                </tr>
                <tr>
                    <td>
                        <p>Confidentiality</p>
                    </td>
                    <td>
                        <xsl:call-template name="modlo-button"/>
                        <p>
                            
                            <span class="instruct">Indicate Moderate [or] Low</span>
                        </p>

                    </td>
                    <td>
                        <p>
                            <b>Unauthorized disclosure of system information could be expected to
                                have a </b>
                            <span class="instruct">serious [or] limited</span>
                            <b> adverse effect on NIST operations, assets, or individuals.</b>
                        </p>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p>Integrity</p>
                    </td>
                    <td>
                        <xsl:call-template name="modlo-button"/>
                        <p>
                            <span class="instruct">Indicate Moderate [or] Low</span>
                        </p>
                    </td>
                    <td>
                        <p>
                            <b>Unauthorized modification or destruction of system information could
                                be expected to have a </b>
                            <span class="instruct">serious [or] limited</span>
                            <b> adverse effect on NIST operations, assets, or individuals.</b>
                        </p>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p>Availability</p>
                    </td>
                    <td>
                        <xsl:call-template name="modlo-button"/>
                        <p>
                            <span class="instruct">Indicate Moderate [or] Low</span>
                        </p>
                    </td>
                    <td>
                        <p>
                            <b>The disruption of access to or use of the system could be expected to
                                have a </b>
                            <span class="instruct">serious [or] limited</span>
                            <b> adverse effect on NIST operations, assets, or individuals.</b>
                        </p>
                    </td>
                </tr>
            </table>


        </section>
    </xsl:template>
    
    <xsl:template name="section2">
        <section id="section2">
            <h1><span class="underline"><span class="num">2.</span> REQUIRED SECURITY CONTROLS</span></h1>
            
            <!--
              Two views are possible, either looking at control-implementation,
            or at the baseline (imported profile). A synthetic view is also possible.
            -->
            <xsl:apply-templates select="/*/control-implementation"/>
        </section>
    </xsl:template>
    
    <xsl:template match="control-implementation">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- only hard-coded URLs just yet; see profile resolution for implementing
         a resource -->
    <xsl:variable name="baseline" select="document(/*/import-profile/@href)"/>
    
    <xsl:key name="control-by-id" match="control" use="@id"/>
    
    <xsl:template match="implemented-requirement">
        <xsl:variable name="baseline-control" select="key('control-by-id',@control-id,$baseline)"/>
        <section class="implemented-requirement">
            <h3>
            <xsl:apply-templates select="$baseline-control/prop[@name = 'label']" mode="spill"/>
            <xsl:text> - </xsl:text>
            <xsl:apply-templates select="$baseline-control/title"/>
                <xsl:for-each select="prop[@name='control-type']" expand-text="true"> ({.})</xsl:for-each>
            </h3>
            <xsl:apply-templates select="description"/>
            <xsl:apply-templates select="$baseline-control">
                <xsl:with-param name="implementation" tunnel="true" select="."/>
            </xsl:apply-templates>
        </section>
    </xsl:template>
    
    <xsl:key name="param-for-id" match="param" use="@id"/>
    <xsl:key name="param-setting-for-id" match="set-param" use="@param-id"/>
    
    <xsl:template match="insert">
        <xsl:param name="implementation" as="element()" tunnel="true"/>
        <xsl:variable name="best-param"
            select="(key('param-for-id',@param-id) intersect ancestor-or-self::*/param)[last()]"/>
        <xsl:variable name="setting" select="key('param-setting-for-id',@param-id,$implementation)"/>
        <!-- Providing substitution via declaration not yet supported -->
        <xsl:variable name="unassigned">
            <xsl:if test="empty($best-param | $setting)"> unassigned</xsl:if>
        </xsl:variable>
        <span class="insert{$unassigned}">
            <xsl:for-each select="($setting,$best-param)[1]">
                    <span class="decorated">
                        <xsl:value-of select="(@id,@param-id)[1]"/>
                    </span>
                    <xsl:text> </xsl:text>
                <xsl:apply-templates mode="inline"/>
                <xsl:if test="empty(value | ./default)">
                    <span class="value">
                        <xsl:apply-templates select="value" mode="param-value"/>
                        <xsl:if test="empty(value)">[NO PARAMETER VALUE GIVEN]</xsl:if>
                    </span>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="empty($setting | $best-param)">[NO PARAMETER ASSIGNED]</xsl:if>
        </span>
    </xsl:template>
    
    <xsl:template match="set-param">
        <xsl:param name="control" as="element()" tunnel="true"/>
        <xsl:variable name="control-param"
            select="key('param-for-id',@param-id,$control/root())"/>
        <p class="set-param">
            <xsl:for-each select="$control-param">
                <span class="decorated">
                  <xsl:value-of select="@id"/>
                </span>
                <xsl:apply-templates/>
            </xsl:for-each>
            <xsl:text>: </xsl:text>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="set-param/* | param/*">
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="control">
        <xsl:apply-templates select="part[@name='statement']"/>
    </xsl:template>
    
    <xsl:template match="control/part[@name='statement']" priority="2">
        <div class="part {@name}">
            <xsl:copy-of select="@id"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="control/part[@name='statement']//p">
        <xsl:choose>
            <xsl:when test=". is ancestor::part[@name='statement']/descendant::p[1]">
                <p><span class="head">Control</span>
                    <xsl:text>: </xsl:text>
                    <xsl:apply-templates/></p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="prop"/>
    
    <xsl:template match="prop" mode="spill">
        <span class="prop {@name}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:key name="statement-by-target" match="statement" use="@statement-id"/>
    
    <xsl:template match="part">
        <xsl:param name="implementation" tunnel="yes"/>
        <div class="part {@name}">
            <xsl:copy-of select="@id"/>
            <xsl:apply-templates/>
            <xsl:apply-templates select="key('statement-by-target',@id,$implementation)">
                <xsl:with-param name="control" tunnel="true" select="ancestor::control[1]"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>
    
    <xsl:template match="part[@name='item']">
        <xsl:param name="implementation" tunnel="yes"/>
        <div class="part">
            <xsl:copy-of select="@id"/>
            <table class="statement-item">
                <tbody>
                    <tr>
                        <td>
                            <xsl:for-each select="prop[@name='label']">
                                <xsl:apply-templates/>
                            </xsl:for-each>
                        </td>
                        <td class="item">
                            <xsl:apply-templates/>
                            <xsl:apply-templates select="key('statement-by-target',@id,$implementation)">
                                <xsl:with-param name="control" tunnel="true" select="ancestor::control[1]"/>
                            </xsl:apply-templates>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>
    
    <xsl:key name="component-by-id" match="component" use="@id"/>
    
    <xsl:template match="by-component">
        <details>
            <summary>
                <xsl:apply-templates select="key('component-by-id',@component-id)/(title,@name,@id)[1]"/>
            </summary>
            <xsl:apply-templates/>
        </details>
    </xsl:template>
    
    <!-- <h1><span class="underline">2. REQUIRED SECURITY CONTROLS</span></h1><section>
<h5/></section><section>
<h2><span class="underline">2.1 Access Control (AC)</span></h2>
<section>
<h3><span class="c0000FF underline">AC-1</span>, Access Control Policy:  (Common)</h3>
<p>The organization:</p>
<p>Develops, documents, and disseminates to: <i>[Assignment</i><b><i>:</i></b><i> organization-defined personnel or roles]</i>[Assignment<b>: </b>System Owner, Information System Security Officer(s), privileged users] an Access Control Policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</p>
<p>Reviews and updates the current Access Control Policy annually.</p>   -->
    
    
    <xsl:template match="p | table | pre | ul | ol">
        <xsl:call-template name="cast-to-html"/>
    </xsl:template>
    
    
    <xsl:template name="cast-to-html">
        <xsl:apply-templates select="." mode="html-ns"/>
    </xsl:template>
    
    <xsl:template match="insert" mode="html-ns">
        <xsl:apply-templates select="." mode="#default"/>
    </xsl:template>
    
    
    <xsl:template match="*" mode="html-ns">
        <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="css">
        <style type="text/css">
            <xsl:text disable-output-escaping="true">
        html, body { font-family: 'Times New Roman', Times, serif }
        
        .instruct            { color: red }
        .response            { padding: 0.2em; color: green; font-weight: bold; background-color: lightyellow }
        .bad                 { padding: 0.2em; color: darkred; font-weight: bold; background-color: pink }
        
        
        .bold                { font-weight: bold }
        .italic              { font-style: italic }
        .underline           { text-decoration: underline }
        .sans-serif          { font-family: sans-serif }
        .monospace           { font-family: monospace }
        .spaceafter          { margin-bottom: 0.5em }
        .hanging.full        { padding-left: 3em; text-indent: -3em }         
        .hanging.half        { padding-left: 1.5em; text-indent: -1.5em }
        .indented            { margin-left: 3em }
        .indented.fiftyone   { margin-left: 51em }
        .indented.ten        { margin-left: 10em }
        .indented.ninehalfs  { margin-left: 4.5em }
        .indented.threehalfs { margin-left: 1.5em }
        
        .bordered { border: thin solid black; padding: 0.2em }
        center    { text-align: center }
        
        
        .c0000FF { color: #0000FF }
        .c243F60 { color: #243F60 }
        .c365F91 { color: #365F91 }
        .c0070C0 { color: #0070C0 }
        .c7030A0 { color: #7030A0 }
        .c808080 { color: #808080 }
        
        th { background-color: gainsboro }
        td, th { border: thin solid black; padding: 0.5em; vertical-align: text-top }
               
        .right-align { text-align: right }
        
        div > * { margin-top: 0em; margin-bottom: 0em }
        
        .withdrawn { background-color: gainsboro }
        .withdrawn .h3 { text-decoration: line-through }
        
        details { border: thin dotted black; padding: 0.2em }
        
        summary > * { display: inline-block; font-family: sans-serif }
        
        summary > h1, summary > h2, summary > h3, summary > h4 { max-width: 80%;
        vertical-align: top; margin: 0em }
        
        h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6, .head { font-family: sans-serif }
        
        .h1 { font-size: 2em;    font-weight: bold }
        .h2 { font-size: 1.5em;  font-weight: bold }
        .h3 { font-size: 1.17em; font-weight: bold }
        .h4 { font-size: 1.0em;  font-weight: bold }
        .h5 { font-size: .83em;  font-weight: bold }
        .h6 { font-size: .67em;  font-weight: bold }
        
        .head { text-decoration: underline }
        
        .insert { font-style: italic; font-weight: bold }
        .insert a { font-size: 80%; font-weight: bold; font-family: sans-serif }
        
        .metadata {  }
        
        .group { border-top: thin solid black; padding: 0.5em 0em }
        
        .references { border-top: thin solid black; padding: 0.5em 0em }
        
        .control { }
        
        .statement { }
        
        .back-matter {  }
        
        .title {  }
        
        .param { margin-top: 0.5em }
        
        .prop {  }
        
        .part { margin-left: 2em; margin-top: 0.5em }
        
        .annotation {  }
        
        .label {  }
        
        .usage {  }
        
        .constraint {  }
        
        .guideline {  }
        
        .value { font-weight: bold; font-style: italic }
        
        .select {  }
        
        .link {  }
        
        .prose {  }
        
        .choice {  }
        
        .decorated { display: inline-block;
        background-color: steelblue; color: white;
        font-size: 80%; font-weight: bold; font-family: sans-serif;
        padding: 0.2em 0.5em; margin: 0em 0.5em 0em 0em }
        
        td { vertical-align: text-top }
        
        td > p { margin: 0em; margin-top: 0.5em }
        td > p:first-child { margin-top: 0em }
        
        .statement-item td, .statement-item th { border: thin solid white; padding: 0.2em }
        td.item:hover { border: thin solid black; padding: 0.2em }
 
        td.item details p { font-size: smaller; margin: 0.5em 0em }
        td.item details p.set-param { font-size: inherit }
        </xsl:text>
        </style>
    </xsl:template>
    
    <xsl:function name="o:title-case" as="xs:string?">
        <xsl:param name="str" as="item()?"/>
        <xsl:value-of select="$str ! ( upper-case(substring(.,1,1)) || substring(.,2) )"/>
    </xsl:function>
</xsl:stylesheet>