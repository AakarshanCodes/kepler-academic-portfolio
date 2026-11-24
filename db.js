// db.js: Universal IndexedDB Client Storage for Kepler Academic Portfolio
// Enables storing files and academic data reliably on static hosts (GitHub Pages) without storage limits

var KeplerDB = (function() {
    const DB_NAME = 'KeplerAcademicPortfolioDB';
    const DB_VERSION = 1;
    let dbInstance = null;

    function openDB() {
        if (dbInstance) return Promise.resolve(dbInstance);
        return new Promise((resolve, reject) => {
            if (typeof indexedDB === 'undefined') {
                return reject(new Error("IndexedDB is not supported in this environment"));
            }
            const req = indexedDB.open(DB_NAME, DB_VERSION);
            req.onupgradeneeded = function(e) {
                const db = e.target.result;
                if (!db.objectStoreNames.contains('files')) {
                    db.createObjectStore('files', { keyPath: 'id' });
                }
                if (!db.objectStoreNames.contains('store')) {
                    db.createObjectStore('store', { keyPath: 'key' });
                }
            };
            req.onsuccess = function(e) {
                dbInstance = e.target.result;
                resolve(dbInstance);
            };
            req.onerror = function(e) {
                console.error("IndexedDB error:", e);
                reject(e);
            };
        });
    }

    async function saveFile(file) {
        const db = await openDB();
        const cleanName = file.name.replace(/[^a-zA-Z0-9._-]/g, '_');
        const id = 'idb://file_' + Date.now() + '_' + cleanName;
        return new Promise((resolve, reject) => {
            const tx = db.transaction('files', 'readwrite');
            const store = tx.objectStore('files');
            const record = {
                id: id,
                name: file.name,
                type: file.type || 'application/octet-stream',
                size: file.size,
                blob: file,
                createdAt: new Date().toISOString()
            };
            const req = store.put(record);
            req.onsuccess = () => resolve({ id: id, url: id, name: file.name, size: file.size, type: record.type });
            req.onerror = (err) => reject(err);
        });
    }

    async function getFile(id) {
        try {
            const db = await openDB();
            return new Promise((resolve) => {
                const tx = db.transaction('files', 'readonly');
                const store = tx.objectStore('files');
                const req = store.get(id);
                req.onsuccess = () => {
                    resolve(req.result || null);
                };
                req.onerror = (err) => {
                    console.error("KeplerDB getFile error:", err);
                    resolve(null);
                };
            });
        } catch(e) {
            console.error("KeplerDB getFile failed:", e);
            return null;
        }
    }

    async function deleteFile(id) {
        try {
            const db = await openDB();
            return new Promise((resolve) => {
                const tx = db.transaction('files', 'readwrite');
                const store = tx.objectStore('files');
                const req = store.delete(id);
                req.onsuccess = () => resolve(true);
                req.onerror = () => resolve(false);
            });
        } catch(e) {
            return false;
        }
    }

    async function setAcademicData(data) {
        try {
            const db = await openDB();
            return new Promise((resolve) => {
                const tx = db.transaction('store', 'readwrite');
                const store = tx.objectStore('store');
                const req = store.put({ key: 'academicData', payload: data, updatedAt: Date.now() });
                req.onsuccess = () => resolve(true);
                req.onerror = () => resolve(false);
            });
        } catch(e) {
            console.error("KeplerDB setAcademicData error:", e);
            return false;
        }
    }

    async function getAcademicData() {
        try {
            const db = await openDB();
            return new Promise((resolve) => {
                const tx = db.transaction('store', 'readonly');
                const store = tx.objectStore('store');
                const req = store.get('academicData');
                req.onsuccess = () => {
                    if (req.result && req.result.payload) resolve(req.result.payload);
                    else resolve(null);
                };
                req.onerror = () => resolve(null);
            });
        } catch(e) {
            console.error("KeplerDB getAcademicData error:", e);
            return null;
        }
    }

    return {
        saveFile,
        getFile,
        deleteFile,
        setAcademicData,
        getAcademicData
    };
})();

// Explicitly export to global scope for all browser execution contexts
if (typeof window !== 'undefined') {
    window.KeplerDB = KeplerDB;
}
if (typeof self !== 'undefined') {
    self.KeplerDB = KeplerDB;
}
