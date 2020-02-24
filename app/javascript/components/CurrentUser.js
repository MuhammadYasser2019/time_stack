import React from "react"
import PropTypes from "prop-types"
class CurrentUser extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            user_projects: []
        }
        this.get_user_projects = this.get_user_projects.bind(this);
    }

    get_user_projects() {
        fetch(`${localStorage.BaseURL}/get_user_projects`, {
            headers: new Headers({
                // 'Authorization': `Bearer ${localStorage.AccessToken}`
            })
        })
            .then(res => res.json())
            .then(res => {
                this.setState({ user_projects: res.result })
            })
        //   .catch(error=>{
        //     this.setState({message: "FAILED ADMIN CALL!"})
        //   });
    }

    componentDidMount() {
        this.get_user_projects();
    }


    render() {
        return (
            <React.Fragment>
                <i>Admin: {this.props.first_name + " " + this.props.last_name}</i>
                {this.state.user_projects && this.state.user_projects.length > 0 ? <div>
                    <b>Total Projects: {this.state.user_projects.length}</b>
                    {
                        this.state.user_projects.sort().map((project, index) => {
return <div key={`project_${index}`}>{`${index+1}. ${project}`}</div>
                        })}
                </div>
                    : null}
            </React.Fragment>
        );
    }
}

CurrentUser.propTypes = {
    first_name: PropTypes.string,
    last_name: PropTypes.string
};
export default CurrentUser
