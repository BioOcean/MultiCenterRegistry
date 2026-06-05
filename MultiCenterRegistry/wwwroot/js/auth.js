window.bioAuthLogin = async function (basePath, account, password) {
    const url = (basePath || '/') + 'api/auth/login';
    try {
        const res = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ account, password }),
            credentials: 'include'
        });

        const text = await res.text();
        return {
            success: res.ok,
            status: res.status,
            message: text || (res.ok ? '登录成功' : '登录失败')
        };
    } catch {
        return {
            success: false,
            status: 0,
            message: '网络错误，请检查网络连接'
        };
    }
}

window.bioAuthLogout = async function (basePath) {
    const url = (basePath || '/') + 'api/auth/logout';
    try {
        await fetch(url, { method: 'POST', credentials: 'include' });
    } catch {
    }

    return true;
}

window.mcrGetRoleList = async function (basePath, account, password) {
    const url = (basePath || '/') + 'api/mcr/auth/roles';
    try {
        const res = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ account, password }),
            credentials: 'include'
        });
        const data = await res.json();
        return {
            success: res.ok && data.success === true,
            status: res.status,
            message: data.message || '',
            roles: data.roles || []
        };
    } catch {
        return {
            success: false,
            status: 0,
            message: '网络错误，请检查网络连接',
            roles: []
        };
    }
}

window.mcrSetSelectedRole = async function (basePath, roleId) {
    const url = (basePath || '/') + 'api/mcr/auth/selected-role';
    try {
        const res = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ roleId }),
            credentials: 'include'
        });
        const data = await res.json();
        return {
            success: res.ok && data.success === true,
            status: res.status,
            message: data.message || ''
        };
    } catch {
        return {
            success: false,
            status: 0,
            message: '网络错误，请检查网络连接'
        };
    }
}

window.mcrClearSelectedRole = async function (basePath) {
    const url = (basePath || '/') + 'api/mcr/auth/selected-role';
    try {
        await fetch(url, { method: 'DELETE', credentials: 'include' });
    } catch {
    }

    return true;
}

window.mcrScrollToElement = function (elementId) {
    const element = document.getElementById(elementId);
    if (!element) {
        return;
    }

    element.scrollIntoView({
        behavior: 'smooth',
        block: 'start'
    });
}
